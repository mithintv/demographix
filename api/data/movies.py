import requests
import os
import json

import credits

key = os.environ['API_KEY']
access_token = os.environ['ACCESS_TOKEN']


def get_movie_by_query():
    search_list = ['The Power of the Dog', 'Belfast', 'Coda', 'Dune', 'King Richard',
                   'Licorice Pizza', 'Nightmare Alley', 'The Tragedy of Macbeth', 'West Side Story']

    movie_list = []
    for search in search_list:
        response = requests.get(
            f'https://api.themoviedb.org/3/search/movie?api_key={key}&query={search}')
        parsed = response.json()
        movie = parsed['results'][0]
        movie_list.append(movie)

    with open('movies.json', 'w') as file:
        json.dump(movie_list, file)


def get_movie_details(movie_id):
    url = f"https://api.themoviedb.org/3/movie/{movie_id}?language=en-US"
    headers = {
        "accept": "application/json",
        "Authorization": f"Bearer {access_token}"
    }
    response = requests.get(url, headers=headers)
    movie_details = response.json()
    return movie_details


movie_ids = credits.get_movie_ids()

movie_details_list = []
for movie_id in movie_ids:
    movie_details = get_movie_details(movie_id)
    movie_details_list.append(movie_details)

with open('movie_details.json', 'w') as file:
    json.dump(movie_details_list, file)
