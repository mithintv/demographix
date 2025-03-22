"""Services to retrieve movie data from The Movie Database (TMDB)."""

import json
import logging
import os

import requests
from data.model import CastMember, Country, Credit, Gender, Movie
from data.movie_repository import MovieRepository
from sqlalchemy import func

key = os.environ["TMDB_API_KEY"]
access_token = os.environ["TMDB_ACCESS_TOKEN"]


class MovieService:
    def __init__(self):
        self.movie_repo = MovieRepository()

    def search_movie(self, search_text):
        """Return search query results from db."""

        searchResults = self.movie_repo.query_movie(search_text)

        if len(searchResults) < 5:
            logging.info("Not enough results in db... making API call...")

            additional_query = (
                self.movie_repo.query(Movie)
                .join(Movie.credits)
                .where(Movie.poster_path is not None)
                .where(func.count(Movie.credits) > 1)
                .order_by(Movie.title.like(f"{search_text[0].lower()}%"))
            )
            searchResults = searchResults.union_all(additional_query)

        return searchResults[:28]

    def search_and_add_movie(self, search_text) -> list[Movie]:
        """Return search query results from api."""

        response = requests.get(
            str.format(
                "https://api.themoviedb.org/3/search/movie?api_key={}&query={}",
                os.environ["TMDB_API_KEY"],
                search_text,
            ),
            timeout=15,
        )
        result_list = response.json()
        movies = result_list["results"]
        logging.info('Found %s movies with query "%s"', len(movies), search_text)

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

    def get_movie_and_cast(self, movie_id: str):
        """Return specific movie with credits and cast member details."""

        movie = Movie.query.filter(Movie.id == movie_id).first()
        if movie is None:
            logging.warning("Movie details are missing for %s", movie_id)
            return {}
            # logging.info("Movie details are missing...\nMaking api call...\n")

            # # Update movie
            # movie_details = query_api_movie_details(movie_id)
            # update_movie_with_movie_details(movie, movie_details)

            # # Get cast list and add cast members
            # cast_credit_list = query_api_credits(movie_id)
            # query_api_people(cast_credit_list)

            # # Add credits after adding cast members
            # add_credits(cast_credit_list, movie)

        logging.info("Fetching details about %s...", movie.title)

        cast_list: list[CastMember] = (
            CastMember.query.join(
                Credit, Credit.cast_member_id == CastMember.id, isouter=True
            )
            .join(Gender, Gender.id == CastMember.gender_id, isouter=True)
            .join(Country, Country.id == CastMember.country_of_birth_id, isouter=True)
            .join(Movie, Movie.id == Credit.movie_id, isouter=True)
            .filter(Movie.id == movie_id)
            .filter(Credit.order < 15)
            .order_by(Credit.order)
            .all()
        )
        cast_details = []
        for cast in cast_list:
            races = [race.name for race in cast.races]
            ethnicities = []
            for cast_ethnicity in cast.ethnicities:
                ethnicities.append(
                    {
                        "name": cast_ethnicity.ethnicity.name,
                        "sources": [source.link for source in cast_ethnicity.sources],
                    }
                )

            new_cast = {
                "id": cast.id,
                "name": cast.name,
                "birthday": cast.birthday,
                "gender": cast.gender.name,
                "ethnicity": ethnicities,
                "race": races,
                "country_of_birth": (
                    cast.country_of_birth.id if cast.country_of_birth else None
                ),
                "character": cast.credits[0].character,
                "order": cast.credits[0].order,
                "profile_path": cast.profile_path,
            }
            cast_details.append(new_cast)

        genre_list = [genre.name for genre in movie.genres]

        movie_dict = movie.to_dict()
        movie_dict["genres"] = genre_list
        movie_dict["cast"] = cast_details

        return movie_dict


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


movie_service = MovieService()
