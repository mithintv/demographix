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


def add_nominations(year, award='Academy Awards', file_path='data/2022.json'):
    with open(file_path, 'r') as file:
        data = json.load(file)

        # Get best picture nominations only
        for nomination in data[0]['nominations']:
            movie = Movie.query.filter_by(name = nomination['primary'][0]).first()
            nomination = Nomination.query.filter_by(and_(name=award, year=year))
            if movie != None:
                movie.nominations.append(nomination)

        db.session.commit()
