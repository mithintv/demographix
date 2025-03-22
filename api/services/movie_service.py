"""Services to retrieve movie data from The Movie Database (TMDB)."""

import json
import logging
import os

import requests
from data.model import Movie
from data.movie_repository import MovieRepository
from sqlalchemy import func

key = os.environ["TMDB_API_KEY"]
access_token = os.environ["TMDB_ACCESS_TOKEN"]


class MovieService:
    def __init__(self):
        self.movie_repo = MovieRepository()

    def search_movie(self, searchText):
        """Return search query results from db."""

        searchResults = self.movie_repo.query_movie(searchText)

        if len(searchResults) < 5:
            logging.info("Not enough results in db... making API call...")

            additional_query = (
                self.movie_repo.query(Movie)
                .join(Movie.credits)
                .where(Movie.poster_path is not None)
                .where(func.count(Movie.credits) > 1)
                .order_by(Movie.title.like(f"{searchText[0].lower()}%"))
            )
            searchResults = searchResults.union_all(additional_query)

        return searchResults[:28]

    def search_keyword_and_add_movie(self, keywords) -> list[Movie]:
        """Return search query results from api."""

        response = requests.get(
            str.format(
                "https://api.themoviedb.org/3/search/movie?api_key={}&query={}",
                os.environ["TMDB_API_KEY"],
                keywords,
            ),
            timeout=15,
        )
        result_list = response.json()
        movies = result_list["results"]
        logging.info('Found %s movies with query "%s"', len(movies), keywords)

        # Add movies to db if they don't already exist
        new_movies = []
        for movie in movies:
            curr_movie = self.movie_repo.get_movie_by_id(movie["id"])
            if curr_movie is None:
                curr_movie = self.create_movie(movie)
                new_movies.append(curr_movie)

        if len(new_movies) > 0:
            logging.info("Added %s movies to db!", len(new_movies))

        return movies


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
