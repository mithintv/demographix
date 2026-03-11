import logging
import os
from datetime import datetime
from typing import Optional, TypedDict

import requests
from sqlalchemy import desc, func

from api.data.model import CastMember, Country, Credit, Gender, Genre, db


class MovieService:
    """Service to retrieve movie data from database."""

    def __init__(self):
        self.db = db.session

    def get_movie_by_id(self, movie_id):
        return Movie.query.filter(Movie.id == movie_id).first()

    def get_movie_and_cast_by_id(self, movie_id: int):
        """Return specific movie with credits and cast member details."""

        movie: Movie = Movie.query.filter(Movie.id == movie_id).first()
        if movie is None:
            logging.warning("Movie details are missing for %s", movie_id)
            return None
            # logging.info("Movie details are missing...\nMaking api call...\n")

            # # Update movie
            # movie_details = query_api_movie_details(movie_id)
            # update_movie_with_movie_details(movie, movie_details)

            # # Get cast list and add cast members
            # cast_credit_list = query_api_credits(movie_id)
            # query_api_people(cast_credit_list)

            # # Add credits after adding cast members
            # add_credits(cast_credit_list, movie)

        logging.info(
            "Fetching details about %s (%s)...",
            movie.title,
            movie.release_date.year,
        )

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

    def search_movie(self, search_text):
        """Return search query results from db."""

        search_results = self._query_movie(search_text)
        if len(search_results.all()) < 20:
            logging.info("Not enough results in db... making 'ends_with' query...")
            additional_query = self._query_movie(
                search_text, {"include_wo_poster": False, "include_ends_with": True}
            )
            search_results = search_results.union_all(additional_query)

        if len(search_results.all()) < 20:
            logging.info("Not enough results in db... making API call...")
            new_movies = self.search_tmdb_and_add(search_text)
            return new_movies[:20]

        return (search_results.all())[:20]

    def search_tmdb_and_add(self, search_text):
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
        result = []
        new_movies = []
        for movie in movies:
            curr_movie = self.get_movie_by_id(movie["id"])
            if curr_movie is None:
                curr_movie = self.create_movie(movie)
                new_movies.append(curr_movie)
            result.append(curr_movie)

        if len(new_movies) > 0:
            logging.info("Added %s movies to db!", len(new_movies))

        return result

    def _query_movie(
        self,
        search_text,
        options={"include_wo_poster": False, "include_ends_with": False},
    ):
        """Return search query results."""

        query = Movie.query.join(Movie.credits, isouter=True)

        if options.get("include_wo_poster") is False:
            query = query.filter(Movie.poster_path != None)

        if len(search_text) > 0:
            if options.get("include_ends_with") is True:
                query = query.filter(
                    func.lower(Movie.title).like(f"%{search_text.lower()}%")
                )
            else:
                query = query.filter(
                    func.lower(Movie.title).like(f"{search_text.lower()}%")
                )
            query = query.order_by(desc(Movie.release_date))
        else:
            query = query.order_by(func.random())

        query = query.group_by(
            Movie.id,
            Movie.imdb_id,
            Movie.title,
            Movie.overview,
            Movie.runtime,
            Movie.poster_path,
            Movie.release_date,
            Movie.budget,
            Movie.revenue,
        )

        logging.info("Found %s movies!", query.count())
        return query


movie_service = MovieService()
