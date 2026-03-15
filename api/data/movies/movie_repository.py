import logging
from datetime import datetime

from sqlalchemy import desc, func, select

from api.data.base import db
from api.data.cast_members.cast_member_dto import CastEthnicityDto, CastMemberCreditDto
from api.data.cast_members.cast_member_model import CastMember
from api.data.credits.credit_model import Credit
from api.data.genres.genre_repository import create_genre, get_genre_by_id
from api.data.model import Country, Gender
from api.data.movies.movie_dto import CreateMovieRequest, MovieDetailsDto
from api.data.movies.movie_model import Movie


def query_movies(
    query_text: str | None,
    options={"include_wo_poster": False, "include_ends_with": False},
):
    """Return search query results."""

    query = Movie.query.join(Movie.credits, isouter=True)

    if options.get("include_wo_poster") is False:
        query = query.filter(Movie.poster_path != None)

    if query_text and len(query_text) > 0:
        if options.get("include_ends_with") is True:
            query = query.filter(
                func.lower(Movie.title).like(f"%{query_text.lower()}%")
            )
        else:
            query = query.filter(func.lower(Movie.title).like(f"{query_text.lower()}%"))
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

    logging.info("Query: %s found %s movies", query.count(), query)
    return query


def find_movie_by_id(id: int):
    """Find movie by id"""
    movie = db.session.scalars(select(Movie).where(Movie.id == id)).one_or_none()
    if movie is not None:
        logging.info("%s found!", movie)
    return movie


def create_movie(data: CreateMovieRequest):
    """Create a new movie in the database."""
    existing_movie = find_movie_by_id(data.id)
    if existing_movie is not None:
        logging.warning("%s already exists", existing_movie)
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
    logging.info("Adding %s", movie)

    for genre in data.genres:
        genre_object = get_genre_by_id(genre.id)
        if genre_object is None:
            genre_object = create_genre(genre.id, genre.name, delay_commit=True)
        movie.genres.append(genre_object)
    db.session.commit()
    return movie


def find_movie_and_details_by_id(movie_id: int):
    """Find movie with details."""
    movie = find_movie_by_id(movie_id)
    if movie is None:
        logging.warning("Movie: %s not found", movie_id)
        return None

    cast_details = []
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
        cast_ethnicities = [
            CastEthnicityDto.from_model(cast_ethnicity)
            for cast_ethnicity in cm.ethnicities
        ]
        cast_races = [race.name for race in cm.races]
        new_cast = CastMemberCreditDto(
            id=cm.id,
            name=cm.name,
            birthday=cm.birthday.isoformat() if cm.birthday else None,
            gender=cm.gender.name,
            ethnicity=cast_ethnicities,
            race=cast_races,
            country_of_birth=(cm.country_of_birth.id if cm.country_of_birth else None),
            character=credit.character,
            order=credit.order,
            profile_path=cm.profile_path,
        )
        cast_details.append(new_cast)

    movie_details = MovieDetailsDto.from_model(
        movie, [genre.name for genre in movie.genres], cast_details
    )
    return movie_details
