import logging
from datetime import datetime

from sqlalchemy import func, select

from api.data.genres.genre_model import Genre
from api.data.genres.genre_repository import create_genre, get_genre_by_id
from api.data.model import db
from api.data.movies.movie_dto import CreateMovieRequest, MovieDto
from api.data.movies.movie_model import Movie
from api.data.nominations.nomination_dto import NominationDto
from api.services.tmdb.tmdb_service import get_tmdb_genres


def get_movie_by_id(id: int):
    """Get movie by id"""
    movie = db.session.scalars(select(Movie).where(Movie.id == id)).one_or_none()
    if movie is None:
        return None

    logging.info("Movie: %s found!", movie)
    return MovieDto.from_model(movie)


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
    db.session.add(movie)

    genre_ids = data.genre_ids or []
    for genre_id in genre_ids:
        genre_object = get_genre_by_id(genre_id)
        if genre_object is None:
            genre_list = get_tmdb_genres()
            tmdb_genre = next(
                (g for g in genre_list["genres"] if g["id"] == genre_id), None
            )
            if tmdb_genre is not None:
                genre_object = create_genre(
                    tmdb_genre["id"], tmdb_genre["name"], delay_commit=True
                )
        if genre_object is not None:
            movie.genres.append(genre_object)

    logging.info("Adding Movie: %s", movie)
    db.session.commit()
    return MovieDto.from_model(movie)
