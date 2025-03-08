import logging
import os
from datetime import datetime

import requests
from data.model import Genre, Movie
from sqlalchemy import and_, desc, func, select


class MovieRepository:
    def __init__(self, db_session):
        self.db_session = db_session

    def query_movie(self, keywords):
        """Return search query results."""

        if keywords == "":
            query = (
                self.db_session.query(Movie)
                .join(Movie.credits)
                .filter(Movie.poster_path is not None)
                .group_by(
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
                .having(func.count(Movie.credits) > 1)
                .order_by(func.random())
                .all()
            )
            return query[:30]

        else:
            keyword_query = (
                self.db_session.query(Movie)
                .join(Movie.credits)
                .group_by(
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
                .having(func.count(Movie.credits) > 1)
                .filter(
                    and_(
                        func.lower(Movie.title).like(f"{keywords.lower()}%"),
                        Movie.poster_path is not None,
                    )
                )
                .order_by(desc(Movie.release_date))
            )
            if len(keyword_query.all()) < 5:
                logging.info("Not enough results in db... making API call...")
                keyword_query = self.query_api_movie(keywords)
            additional_query = (
                self.db_session.query(Movie)
                .join(Movie.credits)
                .filter(Movie.poster_path is not None)
                .group_by(Movie.id)
                .having(func.count(Movie.credits) > 1)
                .order_by(Movie.title.like(f"{keywords[0].lower()}%"))
            )

            combined_query = keyword_query.union_all(additional_query)
            results = combined_query.all()
            self.db_session.close()

            return results[:28]

    def query_api_movie(self, keywords):
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

        new_movies = []
        for movie in movies:
            curr_movie = (
                self.db_session.query(Movie).filter(Movie.id == movie["id"]).first()
            )
            if curr_movie is None:
                if len(movie["release_date"]) > 0:
                    date_format = "%Y-%m-%d"
                    formatted_date = datetime.strptime(
                        movie["release_date"], date_format
                    )
                curr_movie = Movie(
                    id=movie["id"],
                    title=movie["title"],
                    overview=movie["overview"],
                    poster_path=movie["poster_path"],
                    release_date=formatted_date,
                )
                self.db_session.add(curr_movie)

                for genre_id in movie["genre_ids"]:
                    genre_object = (
                        self.db_session.query(Genre).filter(Genre.id == genre_id).one()
                    )
                    curr_movie.genres.append(genre_object)

                logging.info("Adding new move to db: %s", curr_movie)

        self.db_session.commit()
        if len(new_movies) > 0:
            logging.info("Added %s movies to db!", len(new_movies))

        query = (
            self.db_session.query(Movie)
            .filter(func.lower(Movie.title).like(f"{keywords.lower()}%"))
            .order_by(desc(Movie.release_date))
        )

        return query
