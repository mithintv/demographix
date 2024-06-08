import json
import logging
import os
import re
from typing import List

import requests
from bs4 import BeautifulSoup
from sqlalchemy import and_, extract, func

from api.model import Movie, MovieNomination, Nomination, db

TMDB_ACCESS_TOKEN = os.environ["TMDB_ACCESS_TOKEN"]


def query_imdb_event_nominations(event: str, year: int):
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
    scripts = soup.find_all("script")

    # Setup dictionary to scrape data
    data: dict = {}
    for script in scripts:
        for line in script:
            if "IMDbReactWidgets.NomineesWidget.push" in line:
                jsons = re.findall(r"{.*}", line)
                if jsons:
                    data = json.loads(jsons[1])
    categories = data["nomineesWidgetModel"]["eventEditionSummary"]["awards"][0][
        "categories"
    ]

    # Fill nominee data
    nominees = [
        {
            "category": award["categoryName"],
            "nominations": [
                {
                    "notes": nomination["notes"],
                    "won": nomination["isWinner"],
                    "primary": [
                        primary["name"] for primary in nomination["primaryNominees"]
                    ][0],
                    # 'secondary': [secondary['name'] for secondary in nomination['secondaryNominees']]
                }
                for nomination in award["nominations"]
            ],
        }
        for award in categories
        if "Best Motion Picture" in award["categoryName"]
    ]
    return nominees


def make_nominations():
    nominations = []
    for year in range(1929, 2023):
        nomination = Nomination(name="Academy Awards", year=year)
        nominations.append(nomination)
        print(f"Adding {nomination.name} {nomination.year} to db...")
    db.session.add_all(nominations)
    db.session.commit()


def add_nominations_json(year, award="Academy Awards"):
    with open(f"data/{year}.json", "r") as file:
        data = json.load(file)

        # Get best picture nominations only
        for nomination in data[0]["nominations"]:
            movie = Movie.query.filter(
                and_(
                    Movie.title == nomination["primary"][0],
                    extract("year", Movie.release_date) == year - 1,
                )
            ).first()
            nomination = Nomination.query.filter(
                and_(Nomination.name == award, Nomination.year == year)
            ).first()
            if movie is not None:
                movie.nominations.append(nomination)

                date_format = "%Y"
                print(
                    f"Adding {nomination.name} {nomination.year} nomination for {movie.title} ({movie.release_date.strftime(date_format)})"
                )

        db.session.commit()


def create_nomination(event, year) -> None:
    """Create nomination entry for a given event and year in the database."""
    nomination = Nomination(name=event, year=year)
    logging.info(
        "Adding %s %s to db...",
        nomination.name,
        nomination.year,
    )
    db.session.add(nomination)
    db.session.commit()


def get_nom_movies(event: str, year: int) -> List:
    """Return nominated movies and cast demographics for a given year from database. Returns an empty List if nomination year and event combination does not exist in the database."""

    nomination = Nomination.query.filter(
        Nomination.year == year and Nomination.name == event
    ).first()
    if nomination is None:
        return []

    movie_noms = MovieNomination.query.filter(
        MovieNomination.nomination_id == nomination.id
    ).all()

    # Check if there are movies to add if less than 5 nominees
    # if len(movie_noms) < 5:
    #     check_nominations(int(year))
    #     movie_noms = MovieNomination.query.filter(
    #         MovieNomination.nomination_id == nomination.id
    #     ).all()
    #     logging.info(len(movie_noms))

    all_movie_data = []
    for movie_nom in movie_noms:
        movie_data = get_movie_cast(movie_nom.movie_id)
        all_movie_data.append(movie_data)

    return all_movie_data


def check_nominations(year: int) -> None:
    """Check if there are nominated movies to add by first making a query to IMDB for a given event and year and then adding it to the database if it doesn't already exist."""
    nominees = query_imdb_event_nominations("academy awards", year)
    for nominee in nominees[0]["nominations"]:
        title = nominee["primary"]
        print(f"Checking if {title} ({year - 1}) is in db...", end=" ")
        query = Movie.query.filter(
            and_(
                func.lower(Movie.title) == title.lower(),
                extract("year", Movie.release_date) == year - 1,
            )
        ).first()

        if query is None:
            print(f"missing...\nChecking if {title} ({year}) is in db...", end=" ")
            query = Movie.query.filter(
                and_(
                    func.lower(Movie.title) is title.lower(),
                    extract("year", Movie.release_date) == year,
                )
            ).first()

        if query is None:
            url = f"https://api.themoviedb.org/3/search/movie?query={title}&language=en-US&primary_release_year={year - 1}&page=1"
            headers = {
                "accept": "application/json",
                "Authorization": f"Bearer {access_token}",
            }
            response = requests.get(url, headers=headers)
            results = response.json()

            if not results["results"]:
                url = f"https://api.themoviedb.org/3/search/movie?query={title}&language=en-US&primary_release_year={year}&page=1"
                headers = {
                    "accept": "application/json",
                    "Authorization": f"Bearer {access_token}",
                }
                response = requests.get(url, headers=headers)
                results = response.json()
            movie_id = results["results"][0]["id"]
            add_new_movie(movie_id=movie_id)

            query = Movie.query.filter(
                and_(
                    Movie.title == title,
                    extract("year", Movie.release_date) == year - 1,
                )
            ).first()
            if query is None:
                query = Movie.query.filter(
                    and_(
                        Movie.title == title,
                        extract("year", Movie.release_date) == year,
                    )
                ).first()
        else:
            print("found!")

        add_nomination(query, year)

    db.session.commit()
