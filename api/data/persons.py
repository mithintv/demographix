
import os
import requests
import json
from model import db, CastMember
from app import app
from crud import *
from data.ethnicity import *

key = os.environ['TMDB_API_KEY']


def fetch_missing_person_data_json(attribute='profile_path'):
    with open('data/persons.json', 'r') as file:
        data = json.load(file)

        for cast in data:
            cast_member = CastMember.query.filter_by(
                id=cast['id']).one()
            if cast_member.profile_path == None:
                missing_attribute = {
                    str(attribute): cast[attribute]
                }
                CastMember.query.filter_by(
                    id=cast['id']).update(missing_attribute)
                print(
                    f"Added profile_path: {cast[attribute]} to {cast['name']}")

    db.session.commit()


def fetch_missing_person_data_api(attribute='profile_path'):
    all_cast = CastMember.query.filter().all()

    for cast_member in all_cast:
        attr = getattr(cast_member, attribute)
        if attr == None:
            url = f"https://api.themoviedb.org/3/person/{cast_member.id}?api_key={key}"
            response = requests.get(url)
            person = response.json()

            setattr(cast_member, attribute, person[attribute])
            print(
                f"Added profile_path: {person[attribute]} to {cast_member.name}")
    db.session.commit()


def fetch_missing_ethnicity_sources_json():
    with open('data/persons.json', 'r') as file:
        data = json.load(file)

        for cast_dict in data[:1]:
            cast_obj = CastMember.query.filter_by(
                id=cast_dict['id']).one()
            for cast_ethnicity in cast_obj.ethnicities:
                if len(cast_ethnicity.sources) == 0:
                    update_cast_member(cast_obj, cast_dict)

# fetch_missing_person_data_json()
# fetch_missing_person_data_api()
fetch_missing_ethnicity_sources_json()
