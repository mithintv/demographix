
import os
import requests
import json
from model import db, CastMember, AKA
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
            property = getattr(cast_member, attribute)
            if type(property) == list:
                for instance in cast[attribute]:
                    new_aka = AKA(name=instance)
                    cast_member.also_known_as.append(new_aka)

            if type(property) != list and property == None:
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


def fetch_missing_ethnicity_sources_json(name=None):
    with open('data/persons.json', 'r') as file:
        data = json.load(file)

        if name != None:
            cast_obj = CastMember.query.filter_by(name=name).one()
            cast_dict = None
            for cast in data:
                if cast['id'] == cast_obj.id:
                    cast_dict = cast
            update_cast_member(cast_obj, cast_dict)
            print("Sleeping for 5 seconds...\n")

        else:
            for cast_dict in data:
                cast_obj = CastMember.query.filter_by(
                    id=cast_dict['id']).one()
                for cast_ethnicity in cast_obj.ethnicities:
                    if len(cast_ethnicity.sources) == 0:
                        update_cast_member(cast_obj, cast_dict)
                        print("Sleeping for 5 seconds...\n")
                        time.sleep(5)


def fetch_missing_ethnicity_sources_api(name=None):

    query = CastMember.query.filter(len(CastMember.ethnicities) > 0).all()
    # for cast_dict in query:
    #     cast_obj = CastMember.query.filter_by(
    #         id=cast_dict['id']).one()
    #     for cast_ethnicity in cast_obj.ethnicities:
    #         if len(cast_ethnicity.sources) == 0:
    #             update_cast_member(cast_obj, cast_dict)
    #             print("Sleeping for 5 seconds...\n")
    #             time.sleep(5)

fetch_missing_person_data_json('also_known_as')
# fetch_missing_person_data_api()
# fetch_missing_ethnicity_sources_json()
# fetch_missing_ethnicity_sources_api()
