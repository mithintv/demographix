import logging
from datetime import datetime

from sqlalchemy import select

from api.data.base import db
from api.data.cast_members.cast_member_model import CastMember
from api.data.credits.credit_model import Credit
from api.data.genres.genre_repository import create_genre, get_genre_by_id
from api.data.model import Country, Gender
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


def get_movie_and_cast_details_by_movie_id(movie_id: int):
    """Return specific movie with credits and cast member details."""
    movie = get_movie_by_id(movie_id)
    if movie is None:
        return None

    cast_details = []
    ethnicities = []
    races = []
    credits = db.session.scalars(
        select(Credit)
        .join(CastMember, Credit.cast_member_id == CastMember.id)
        .join(Gender, Gender.id == CastMember.gender_id, isouter=True)
        .join(Country, Country.id == CastMember.country_of_birth_id, isouter=True)
        .filter(Credit.movie_id == movie_id)
        .filter(Credit.order < 15)
        .order_by(Credit.order)
    ).all()
    for credit in credits:
        cm = credit.cast_member
        races = [race.name for race in cm.races]
        for cast_ethnicity in cm.ethnicities:
            ethnicities.append(
                {
                    "name": cast_ethnicity.ethnicity.name,
                    "sources": [source.link for source in cast_ethnicity.sources],
                }
            )

        new_cast = {
            "id": cm.id,
            "name": cm.name,
            "birthday": cm.birthday,
            "gender": cm.gender.name,
            "ethnicity": ethnicities,
            "race": races,
            "country_of_birth": (
                cm.country_of_birth.id if cm.country_of_birth else None
            ),
            "character": credit.character,
            "order": credit.order,
            "profile_path": cm.profile_path,
        }
        cast_details.append(new_cast)

    movie_dict = movie.to_dict()
    movie_dict["genres"] = [genre.name for genre in movie.genres]
    movie_dict["cast"] = cast_details

    return movie_dict
