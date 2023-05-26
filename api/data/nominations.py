import json
from sqlalchemy import and_
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
            movie = Movie.query.filter_by(title=nomination['primary'][0]).first()
            nomination = Nomination.query.filter(and_(Nomination.name == award, Nomination.year == year)).first()
            if movie != None:
                movie.nominations.append(nomination)
                print(f"Adding {nomination.name} {nomination.year} nomination for {movie.title}")

        db.session.commit()
