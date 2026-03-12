import logging
import os
from datetime import datetime
from typing import Optional, TypedDict

import requests
from sqlalchemy import desc, func

from api.data.model import Country, Gender, db


class MovieService:
    """Service to retrieve movie data from database."""

    def __init__(self):
        self.db = db.session

    def get_movie_by_id(self, movie_id):
        return Movie.query.filter(Movie.id == movie_id).first()

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
