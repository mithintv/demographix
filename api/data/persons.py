
import json
import os

import requests
from crud import *
from model import AlsoKnownAs, CastMember, db
from services.ethnicity import *

key = os.environ['TMDB_API_KEY']


def fetch_missing_attr_data_json(attribute='profile_path'):
    with open('data/persons.json', 'r') as file:
        data = json.load(file)

        for cast in data:
            cast_member = CastMember.query.filter_by(
                id=cast['id']).one()
            property = cast.get(attribute, None)
            if  type(property) == list:
                for instance in cast[attribute]:
                    new_aka = AlsoKnownAs.query.filter(AlsoKnownAs.name == instance).first()
                    if new_aka == None:
                        new_aka = AlsoKnownAs(name=instance)
                        cast_member.also_known_as.append(new_aka)
                        print(f"Added alternative name {new_aka.name} for {cast_member.name}")

            # if type(property) != list and property == None:
            #     missing_attribute = {
            #         str(attribute): cast[attribute]
            #     }
            #     CastMember.query.filter_by(
            #         id=cast['id']).update(missing_attribute)
            #     print(
            #         f"Added {attribute}: {cast[attribute]} to {cast['name']}")

    db.session.commit()


def fetch_missing_attr_data_api(all_cast, attribute='profile_path'):

    for cast_member in all_cast:
        attr = getattr(cast_member, attribute)
        if attr == None:
            url = f"https://api.themoviedb.org/3/person/{cast_member.id}?api_key={key}"
            response = requests.get(url)
            person = response.json()

            setattr(cast_member, attribute, person[attribute])
            print(
                f"Added {attribute}: {person[attribute]} to {cast_member.name}")
    db.session.commit()


def fetch_missing_list_data_api(credits, attribute='profile_path'):

    for credit in credits:
        attr = getattr(credit.cast_member, attribute)
        if len(attr) == 0:
            url = f"https://api.themoviedb.org/3/person/{credit.cast_member.id}?api_key={key}"
            response = requests.get(url)
            person = response.json()

            for aka in person['also_known_as']:
                new_aka = AlsoKnownAs.query.filter(AlsoKnownAs.name == aka).first()
                if new_aka == None:
                    new_aka = AlsoKnownAs(name=aka)
                    credit.cast_member.also_known_as.append(new_aka)
                    print(f"Added alternative name {new_aka.name} for {credit.cast_member.name}")

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

# fetch_missing_person_data_json('also_known_as')
# fetch_missing_person_data_api()
# fetch_missing_ethnicity_sources_json()
# fetch_missing_ethnicity_sources_api()
