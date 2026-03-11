import logging
from datetime import datetime

from sqlalchemy import func, select

from api.data.model import Genre, db
from api.data.movies.movie_dto import CreateMovieRequest, MovieDto
from api.data.movies.movie_model import Movie
from api.data.nominations.nomination_dto import NominationDto


def query_movie_by_id(id: int):
    """Query movie by id"""
    movie = db.session.scalars(select(Movie).where(Movie.id == id)).one_or_none()
    if movie is None:
        return None

    logging.info("Movie: %s found!", movie)
    return MovieDto.from_model(movie)


def query_movie_by_title_and_year(title: str, year: int):
    """Query movie by title and year"""
    logging.info("Querying Movie: %s (%s)", title, year)
    movie = db.session.scalars(
        select(Movie)
        .where(func.lower(Movie.title) == title.lower())
        .where(func.extract("year", Movie.release_date) == year)
    ).one_or_none()
    if movie is None:
        return None

    logging.info("Movie: %s found!", movie)
    return MovieDto.from_model(movie)


def create_movie(data: CreateMovieRequest):
    """Create a new movie in the database."""
    existing_movie = query_movie_by_id(data.id)
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
    genre_ids = data.genre_ids or []
    for genre_id in genre_ids:
        genre_object = db.session.scalars(
            select(Genre).where(Genre.id == genre_id)
        ).one()
        movie.genres.append(genre_object)

    logging.info("Adding Movie: %s", movie)
    db.session.add(movie)
    db.session.commit()
    return MovieDto.from_model(movie)
