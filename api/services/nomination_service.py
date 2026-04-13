import os

from bs4 import BeautifulSoup
from playwright.sync_api import sync_playwright
from playwright_stealth import Stealth

from api.data.cast_members.cast_member_repository import (
    create_cast_member,
    find_cast_member_by_id,
)
from api.data.credits.credit_repository import create_credits
from api.data.movies.movie_dto import CreateMovieRequest
from api.data.movies.movie_repository import create_movie
from api.data.nominations.nomination_dto import ImdbCategory
from api.data.nominations.nomination_repository import (
    create_movie_nomination,
    get_nominations_by_imdb_event_id_and_award_year,
    query_nomination_awards,
)
from api.services.logging_service import get_logger
from api.services.tmdb.tmdb_service import (
    find_tmdb_movie_by_imdb_id,
    get_tmdb_credits_by_movie_id,
    get_tmdb_movie_by_id,
    get_tmdb_person_by_id,
)

TMDB_ACCESS_TOKEN = os.environ["TMDB_ACCESS_TOKEN"]
logger = get_logger(__name__)


def scrape_imdb_event_nominations(
    imdb_event_id: str, year: int, award_id: int | None = None
) -> list[ImdbCategory]:
    """Query nominations for a given event and year from IMDB."""

    logger.info("Starting IMDB scraping...")

    awards = query_nomination_awards(imdb_event_id=imdb_event_id, award_id=award_id)
    logger.info("Awards: %s", awards)

    url = f"https://www.imdb.com/event/{imdb_event_id}/{year}/1/"
    with Stealth().use_sync(sync_playwright()) as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        page.goto(url, wait_until="domcontentloaded", timeout=15000)
        try:
            page.wait_for_selector("section", timeout=15000)
        except Exception:
            pass
        logger.info("Page title: %s Page URL: %s", page.title(), page.url)
        html = page.content()
        browser.close()

    soup = BeautifulSoup(html, features="html.parser")
    parent_sections = [
        tag
        for tag in soup.find_all("section")
        if any(tag.get("data-testid", "") == a.name.replace(" ", "") for a in awards)
    ]

    if parent_sections is None:
        logger.warn("<section data-testid='Best...'> not found!")
        return []

    # Fill nominee data
    nominees: list[ImdbCategory] = []
    for section in parent_sections:
        ul = section.find("ul")
        items = ul.find_all("li") if ul else []
        nominations = []

        for item in items:
            a = item.find("a", class_="ipc-title-link-wrapper")
            href = str(a.get("href", "")) if a else ""
            imdb_id = (
                href.split("/title/")[-1].split("/")[0] if "/title/" in href else None
            )
            nominations.append(
                {
                    "won": item.find("div", class_="ipc-signpost__text") is not None,
                    "primary": imdb_id,
                }
            )
        nominees.append(
            {
                "category": h3.get_text(strip=True)
                if (h3 := section.find("h3", class_="ipc-title__text"))
                else "",
                "nominations": nominations,
            }
        )
    logger.info("Nominees %s", nominees)
    return nominees


def check_nominations(
    imdb_event_id: str,
    year: int,
    award_id: int | None,
):
    """Check if there are nominated movies to add by first scraping IMDB for a given event and year and then adding it to the database if it doesn't already exist."""

    logger.info("Checking %s %s for movies", imdb_event_id, year)

    nominations = get_nominations_by_imdb_event_id_and_award_year(
        imdb_event_id, year, award_id
    )
    nominee_categories = scrape_imdb_event_nominations(imdb_event_id, year, award_id)
    for award_category in nominee_categories:
        matched_nomination = [
            nom for nom in nominations if nom.award.name == award_category["category"]
        ]
        nomination = matched_nomination[0] if matched_nomination else None
        if nomination is None:
            logger.warning(
                "Cannot find Award: %s Year: %s in database. Skipping...",
                award_category["category"],
                year,
            )
            continue

        for nominee in award_category["nominations"]:
            imdb_id = nominee["primary"]
            if imdb_id is None:
                continue

            results = find_tmdb_movie_by_imdb_id(imdb_id)
            if not results["movie_results"]:
                logger.warning("No TMDB result for IMDB ID %s", imdb_id)
                continue

            tmdb_id = results["movie_results"][0]["id"]
            tmdb_movie = get_tmdb_movie_by_id(movie_id=tmdb_id)
            movie = create_movie(CreateMovieRequest.from_tmdb(tmdb_movie))

            tmdb_credits = get_tmdb_credits_by_movie_id(tmdb_id)
            for credit in tmdb_credits["cast"]:
                if find_cast_member_by_id(credit["id"]) is None:
                    tmdb_person = get_tmdb_person_by_id(credit["id"])
                    create_cast_member(tmdb_person)
            create_credits(tmdb_credits)
            create_movie_nomination(movie, nomination)
    return True
