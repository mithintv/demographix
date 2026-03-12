import logging
import os

import requests
from bs4 import BeautifulSoup

from api.data.model import db
from api.data.movies.movie_dto import CreateMovieRequest
from api.data.movies.movie_repository import create_movie
from api.data.nominations.nomination_dto import ImdbCategory
from api.data.nominations.nomination_repository import (
    create_movie_nomination,
    get_nomination_by_name_and_year,
)
from api.services.tmdb.tmdb_service import (
    find_tmdb_movie_by_imdb_id,
    get_tmdb_movie_by_id,
)

TMDB_ACCESS_TOKEN = os.environ["TMDB_ACCESS_TOKEN"]


def scrape_imdb_event_nominations(event: str, year: int) -> list[ImdbCategory]:
    """Query nominations for a given event and year from IMDB."""

    # Setup IMDB scraping
    events = {
        "academy awards": "ev0000003",
        "bafta": "ev0000123",
        "golden globes": "ev0000292",
    }
    response = requests.get(
        f"https://www.imdb.com/event/{events[event]}/{year}/1/",
        headers={
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36 Edg/113.0.1774.57",
        },
        timeout=15,
    )
    soup = BeautifulSoup(response.text, features="html.parser")
    parent_sections = [
        tag
        for tag in soup.find_all("section")
        if str(tag.get("data-testid", "")).startswith("Best")
    ]

    if parent_sections is None:
        print("<section data-testid='Best...'> not found!")
        return []

    # Fill nominee data
    nominees: list[ImdbCategory] = []
    for section in parent_sections:
        if section.get("data-testid") != "BestMotionPictureoftheYear":
            continue
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
        nominees.append({"category": "Best Motion Picture", "nominations": nominations})
    return nominees


def check_nominations(
    name: str,
    year: int,
) -> None:
    """Check if there are nominated movies to add by first scraping IMDB for a given event and year and then adding it to the database if it doesn't already exist."""

    logging.info("Checking %s %s for movies", name, year)
    nomination = get_nomination_by_name_and_year(name, year)
    if nomination is None:
        raise Exception("Nomination: %s %s doesn't exist!", nomination, year)

    nominees = scrape_imdb_event_nominations(name, year)
    for nominee in nominees[0]["nominations"]:
        imdb_id = nominee["primary"]
        if imdb_id is None:
            continue

        results = find_tmdb_movie_by_imdb_id(imdb_id)
        if not results["movie_results"]:
            logging.warning("No TMDB result for IMDB ID %s", imdb_id)
            continue

        tmdb_movie = get_tmdb_movie_by_id(movie_id=results["movie_results"][0]["id"])
        movie = create_movie(CreateMovieRequest.from_tmdb(tmdb_movie))
        create_movie_nomination(movie, nomination)
