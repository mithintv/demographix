import logging
from datetime import datetime
from typing import Optional, TypedDict

from data.model import Genre, Movie, db
from sqlalchemy import desc, func
from sqlalchemy.orm import Session


class CreateMovie(TypedDict):
    id: int
    title: str
    overview: str
    poster_path: str
    release_date: Optional[str]
    genre_ids: Optional[list[int]]


class MovieRepository:
    def __init__(self, db_session: Session = db.session):
        self.db = db_session

    def create_movie(
        self,
        movie_data: CreateMovie,
    ):
        """Create a new movie in the database."""
        formatted_date = None
        if len(movie_data["release_date"]) > 0:
            formatted_date = datetime.strptime(movie["release_date"], "%Y-%m-%d")

        movie = Movie(
            id=movie_data["id"],
            title=movie_data["title"],
            overview=movie_data["overview"],
            poster_path=movie_data["poster_path"],
            release_date=formatted_date,
        )
        self.db_session.add(movie)

        for genre_id in movie_data["genre_ids"]:
            genre_object = (
                self.db_session.query(Genre).filter(Genre.id == genre_id).one()
            )
            movie.genres.append(genre_object)

        self.db_session.commit()
        logging.info("Adding new move to db: %s", movie)

        return movie

    def get_movie_by_id(self, movie_id):
        return Movie.query.filter(Movie.id == movie_id).first()

    def query_movie(
        self,
        search_text,
        options={"include_wo_poster": False},
    ):
        """Return search query results."""

        query = (
            self.db.query(Movie)
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
        )

        if options.get("include_wo_poster") is False:
            query = query.filter(Movie.poster_path is not None)

        if len(search_text) > 0:
            query = query.filter(
                func.lower(Movie.title).like(f"{search_text.lower()}%")
            )

        return (
            query.having(func.count(Movie.credits) > 1)
            .order_by(desc(Movie.release_date))
            .all()
        )
