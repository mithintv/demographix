import json
import os

import requests

import api.crud
from api.data.model import CastMember, db

key = os.environ["TMDB_API_KEY"]


def get_movie_ids(file_path="movies.json"):
    """Return a list of movie ids from sample json file created from api call."""

    id_list = []
    with open(file_path, "r") as file:
        data = json.load(file)
        for movie in data:
            id_list.append(movie["id"])
    return id_list


def get_credits(movie_id_list):
    """Create json file of credits for a given list of movie ids."""

    credits_list = []
    for movie_id in movie_id_list:
        url = f"https://api.themoviedb.org/3/movie/{movie_id}/credits?api_key={key}&language=en-US"
        response = requests.get(url)
        credit = response.json()
        credits_list.append(credit)

    with open("credits.json", "w") as file:
        json.dump(credits_list, file)


def parse_credits(file_path="credits.json"):
    """For each credit, parse through top 10 cast, and return list of person ids."""

    person_ids = set([])
    with open(file_path, "r") as file:
        data = json.load(file)
        for credit in data:
            for i in range(len(credit["cast"])):
                person_id = credit["cast"][i]["id"]
                person_ids.add(person_id)
    print(len(person_ids))
    return list(person_ids)


def get_person(person_id_list):
    """Given list of person ids, return info to seed database."""

    persons = []
    for person_id in person_id_list:
        url = f"https://api.themoviedb.org/3/person/{person_id}?api_key={key}"
        response = requests.get(url)
        person = response.json()
        persons.append(person)

        with open("data/persons.json", "a") as file:
            json.dump(persons, file)


def add_missing_persons(file_path="persons.json"):
    with open(file_path, "r") as file:
        data = json.load(file)

        new_persons = []
        for person in data:
            cast_member = CastMember.query.filter(CastMember.id == person["id"]).first()
            if cast_member == None:
                new_person = crud.add_cast_member(person)
                new_persons.append(new_person)
                print(f"Adding {new_person.name} to db...")

        db.session.add_all(new_persons)
        db.session.commit()
        print(f"Added {len(new_persons)} cast members to db!")


# movie_ids = get_movie_ids() # get list of movie ids
# get_credits(movie_ids) # create credits.json
# get list of person ids per movie
# person_ids = parse_credits('data/credits.json')
# get_person(person_ids)  # create persons.json

add_missing_persons("data/persons.json")
