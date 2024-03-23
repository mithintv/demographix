import json
import os
import re

import requests
from bs4 import BeautifulSoup
from model import Movie, Nomination, db
from sqlalchemy import and_, extract

TMDB_ACCESS_TOKEN = os.environ["TMDB_ACCESS_TOKEN"]


def find_nominations(year, event="academy awards"):
    events = {"academy awards": "ev0000003", "golden globes": "ev0000292"}
    response = requests.get(
        f"https://www.imdb.com/event/{events[event]}/{year}/1/",
        headers={
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36 Edg/113.0.1774.57",
        },
    )
    soup = BeautifulSoup(response.text, features="html.parser")
    scripts = soup.find_all("script")

    data = dict()
    for script in scripts:
        for line in script:
            if "IMDbReactWidgets.NomineesWidget.push" in line:
                jsons = re.findall(r"{.*}", line)
                if jsons:
                    data = json.loads(jsons[1])

    categories = data["nomineesWidgetModel"]["eventEditionSummary"]["awards"][0][
        "categories"
    ]
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
            if movie != None:
                movie.nominations.append(nomination)

                date_format = "%Y"
                print(
                    f"Adding {nomination.name} {nomination.year} nomination for {movie.title} ({movie.release_date.strftime(date_format)})"
                )

        db.session.commit()
