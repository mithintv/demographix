import logging
from datetime import datetime

from sqlalchemy import select

from api.data.base import db
from api.data.genres.genre_repository import create_genre, get_genre_by_id
from api.data.movies.movie_dto import CreateMovieRequest, MovieDto
from api.data.movies.movie_model import Movie


def get_movie_by_id(id: int):
    """Get movie by id"""
    movie = db.session.scalars(select(Movie).where(Movie.id == id)).one_or_none()
    if movie is not None:
        logging.info("Movie: %s found!", movie)
    return movie


def create_movie(data: CreateMovieRequest):
    """Create a new movie in the database."""
    existing_movie = get_movie_by_id(data.id)
    if existing_movie is not None:
        logging.warning("Movie: %s already exists!", existing_movie)
        return existing_movie

    movie = Movie(
        id=data.id,
        imdb_id=data.imdb_id,
        title=data.title,
        overview=data.overview,
        runtime=data.runtime,
        poster_path=data.poster_path,
        release_date=(
            datetime.strptime(data.release_date, "%Y-%m-%d")
            if data.release_date is not None
            else None
        ),
        budget=data.budget,
        revenue=data.revenue,
    )
    logging.info("Adding Movie: %s", movie)
    db.session.add(movie)

    for genre in data.genres:
        genre_object = get_genre_by_id(genre.id)
        if genre_object is None:
            genre_object = create_genre(genre.id, genre.name, delay_commit=True)
        movie.genres.append(genre_object)
    db.session.commit()

    return movie
