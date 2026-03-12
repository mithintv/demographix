import logging

from sqlalchemy import func, select

from api.data.model import db
from api.data.movies.movie_model import Movie
from api.data.nominations.nomination_model import MovieNomination, Nomination


def query_nominations(search: str | None):
    stmt = select(Nomination)
    if search:
        stmt = stmt.where(Nomination.name.like(f"%{search}%"))
    nominations = db.session.scalars(
        stmt.outerjoin(MovieNomination, MovieNomination.nomination_id == Nomination.id)
        .outerjoin(Movie, Movie.id == MovieNomination.movie_id)
        .distinct()
        .order_by(Nomination.name, Nomination.year.desc())
    ).all()

    return [nomination for nomination in nominations]


def get_nomination_by_name_and_year(name: str, year: int):
    nomination = db.session.scalars(
        select(Nomination)
        .where(func.lower(Nomination.name) == name.lower())
        .where(Nomination.year == year)
    ).one_or_none()
    if nomination is None:
        return None

    return nomination


def get_movie_nominations_by_nomination_id(nomination_id: int):
    movie_nominations = db.session.scalars(
        select(MovieNomination)
        .join(Movie, Movie.id == MovieNomination.movie_id)
        .where(MovieNomination.nomination_id == nomination_id)
    ).all()
    return movie_nominations


def create_nomination(name: str, year: int):
    """Create new nomination by nomination name and nomination year"""
    existing_nom = db.session.scalars(
        select(Nomination)
        .where(Nomination.name == name.strip().lower())
        .where(Nomination.year == year)
    ).first()
    if existing_nom is not None:
        logging.error("%s %s already exists", name, year)
        return existing_nom

    nomination = Nomination(name=name, year=int(year))
    logging.info("Adding Nomination: %s", nomination)
    db.session.add(nomination)
    db.session.commit()

    return nomination


def create_movie_nomination(movie: Movie, nomination: Nomination):
    movie_nomination = db.session.scalars(
        select(MovieNomination)
        .where(MovieNomination.movie_id == movie.id)
        .where(MovieNomination.nomination_id == nomination.id)
    ).one_or_none()
    if movie_nomination is not None:
        logging.warning("Nomination: %s already exists", movie_nomination)
        return movie_nomination

    movie_nomination = MovieNomination(movie.id, nomination.id)
    logging.info("Adding MovieNomination: %s", movie_nomination)
    db.session.add(movie_nomination)
    db.session.commit()

    return movie_nomination
