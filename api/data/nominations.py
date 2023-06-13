import json, requests, time, re, os
from datetime import datetime
from bs4 import BeautifulSoup
from sqlalchemy import and_, extract, func

from model import *
import crud
import app

TMDB_ACCESS_TOKEN = os.environ['TMDB_ACCESS_TOKEN']

def find_nominations(year, event='academy awards'):
    events = {
        'academy awards': 'ev0000003',
        'golden globes': 'ev0000292'
    }
    response = requests.get(f"https://www.imdb.com/event/{events[event]}/{year}/1/", headers={
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36 Edg/113.0.1774.57",
    })
    soup = BeautifulSoup(response.text, features="html.parser")
    scripts = soup.find_all('script')

    data = dict()
    for script in scripts:
        for line in script:
            if 'IMDbReactWidgets.NomineesWidget.push' in line:
                jsons = re.findall(r'{.*}', line)
                if jsons:
                    data = json.loads(jsons[1])

    categories = data['nomineesWidgetModel']['eventEditionSummary']['awards'][0]['categories']
    nominees = [
                {
                    'category': award['categoryName'],
                    'nominations': [
                        {
                            'notes': nomination['notes'],
                            'won': nomination['isWinner'],
                            'primary': [primary['name'] for primary in nomination['primaryNominees']][0],
                            # 'secondary': [secondary['name'] for secondary in nomination['secondaryNominees']]
                        }
                        for nomination in award['nominations']
                    ]
                }
                for award in categories if 'Best Motion Picture' in award['categoryName']
            ]
    return nominees


def check_nominations(year: int) -> None:
    nominees = find_nominations(year)
    for nominee in nominees[0]['nominations']:
        title = nominee['primary']
        print(f"Checking if {title} ({year - 1}) is in db...", end=" ")
        query = Movie.query.filter(and_(func.lower(Movie.title) == title.lower(), extract('year', Movie.release_date) == year - 1)).first()

        if query == None:
            print(f"missing...\nChecking if {title} ({year}) is in db...", end=" ")
            query = Movie.query.filter(and_(func.lower(Movie.title) == title.lower(), extract('year', Movie.release_date) == year)).first()

        if query == None:
            url = f"https://api.themoviedb.org/3/search/movie?query={title}&language=en-US&primary_release_year={year - 1}&page=1"
            headers = {
                "accept": "application/json",
                "Authorization": f"Bearer {TMDB_ACCESS_TOKEN}"
            }
            response = requests.get(url, headers=headers)
            results = response.json()

            if not results['results']:
                url = f"https://api.themoviedb.org/3/search/movie?query={title}&language=en-US&primary_release_year={year}&page=1"
                headers = {
                    "accept": "application/json",
                    "Authorization": f"Bearer {TMDB_ACCESS_TOKEN}"
                }
                response = requests.get(url, headers=headers)
                results = response.json()
            movie_id = results['results'][0]['id']
            crud.add_new_movie(movie_id=movie_id)

            query = Movie.query.filter(and_(Movie.title == title, extract('year', Movie.release_date) == year - 1)).first()
            if query == None:
                query = Movie.query.filter(and_(Movie.title == title, extract('year', Movie.release_date) == year)).first()
        else:
            print("found!")

        crud.add_nomination(query, year)

    db.session.commit()


def make_nominations():
    nominations = []
    for year in range(1929, 2023):
        nomination = Nomination(name='Academy Awards', year=year)
        nominations.append(nomination)
        print(f"Adding {nomination.name} {nomination.year} to db...")
    db.session.add_all(nominations)
    db.session.commit()


def add_nominations_json(year, award='Academy Awards'):
    with open(f'data/{year}.json', 'r') as file:
        data = json.load(file)

        # Get best picture nominations only
        for nomination in data[0]['nominations']:
            movie = Movie.query.filter(and_(Movie.title == nomination['primary'][0], extract('year', Movie.release_date) == year - 1)).first()
            nomination = Nomination.query.filter(and_(Nomination.name == award, Nomination.year == year)).first()
            if movie != None:
                movie.nominations.append(nomination)

                date_format = '%Y'
                print(f"Adding {nomination.name} {nomination.year} nomination for {movie.title} ({movie.release_date.strftime(date_format)})")

        db.session.commit()
