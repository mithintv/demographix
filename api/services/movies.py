"""Services to retrieve movie data from The Movie Database (TMDB)."""

import json
import os

import requests

key = os.environ["TMDB_API_KEY"]
access_token = os.environ["TMDB_ACCESS_TOKEN"]


def get_movie_details(movie_id):
    """Get movie details from TMDB via a movie_id."""
    response = requests.get(
        url=f"https://api.themoviedb.org/3/movie/{movie_id}?language=en-US",
        headers={
            "accept": "application/json",
            "Authorization": f"Bearer {access_token}",
        },
        timeout=15,
    )
    movie_details = response.json()
    return movie_details


def get_movie_by_query(search_list=None):
    """Get movie details for a predefined list of search queries and dump the result into 'movies.json'."""
    if search_list is None:
        search_list = [
            "The Power of the Dog",
            "Belfast",
            "Coda",
            "Dune",
            "King Richard",
            "Licorice Pizza",
            "Nightmare Alley",
            "The Tragedy of Macbeth",
            "West Side Story",
        ]

    movie_list = []
    for search in search_list:
        response = requests.get(
            f"https://api.themoviedb.org/3/search/movie?api_key={key}&query={search}",
            timeout=15,
        )
        parsed = response.json()
        movie = parsed["results"][0]
        movie_list.append(movie)

    with open("movies.json", "w", encoding="utf-8") as file:
        json.dump(movie_list, file)
