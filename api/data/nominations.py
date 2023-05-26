import json
from sqlalchemy import and_, extract
from model import *
import app


def make_nominations():
    nominations = []
    for year in range(1929, 2023):
        nomination = Nomination(name='Academy Awards', year=year)
        nominations.append(nomination)
        print(f"Adding {nomination.name} {nomination.year} to db...")
    db.session.add_all(nominations)
    db.session.commit()


def add_nominations(year, award='Academy Awards'):
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
