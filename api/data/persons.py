
import os
import requests
import json
import crud
import model

key = os.environ['TMDB_API_KEY']


def fetch_missing_person_data(attribute='profile_path'):
    # all_cast = model.CastMember.query.filter().all()
    # for cast in all_cast:
    # url = f"https://api.themoviedb.org/3/person/{cast['id']}?api_key={key}"
    # response = requests.get(url)
    # person = response.json()
    with open('persons.json', 'r') as file:
        data = json.load(file)

        missing_attribute = {
            [attribute]: cast[attribute]
        }
        for cast in data:
            model.CastMember.query.filter_by(
                id=cast['id']).update(missing_attribute)

    model.db.session.commit()
