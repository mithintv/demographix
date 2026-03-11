import logging

from sqlalchemy import func, select

from api.data.model import CastMember, db
from api.data.movies.movie_dto import MovieDto
from api.data.movies.movie_model import Movie
from api.data.nominations.nomination_dto import MovieNominationDto, NominationDto
from api.data.nominations.nomination_model import MovieNomination, Nomination


def get_nomination_by_name_and_year(name: str, year: int):
    nomination = db.session.scalars(
        select(Nomination)
        .where(func.lower(Nomination.name) == name.lower())
        .where(Nomination.year == year)
    ).one_or_none()
    if nomination is None:
        return None

    return NominationDto.from_model(nomination)


def search_nominations(search: str | None):
    stmt = select(Nomination)
    if search:
        stmt = stmt.where(Nomination.name.like(f"%{search}%"))
    nominations = db.session.scalars(
        stmt.outerjoin(MovieNomination, MovieNomination.nomination_id == Nomination.id)
        .outerjoin(Movie, Movie.id == MovieNomination.movie_id)
        .distinct()
        .order_by(Nomination.name, Nomination.year.desc())
    ).all()

    # results: list[NominationDto] = []
    # for nom in nominations:
    #     movies = (
    #         db.session.query(Movie)
    #         .join(MovieNomination, Movie.id == MovieNomination.movie_id)
    #         .filter(MovieNomination.nomination_id == nom.id)
    #         .order_by(Movie.title)
    #         .all()
    #     )
    #     nomination_movies: list[MovieDto] = [MovieDto.from_model(m) for m in movies]
    #     results.append(
    #         NominationDto(
    #             id=nom.id,
    #             name=nom.name,
    #             year=nom.year,
    #             movies=nomination_movies,
    #         )
    #     )
    return [NominationDto.from_model(nomination) for nomination in nominations]


def create_nomination(name: str, year: int):
    """Create new nomination by nomination name and nomination year"""
    existing_nom = db.session.scalars(
        select(Nomination)
        .where(Nomination.name == name.strip().lower())
        .where(Nomination.year == year)
    ).first()
    if existing_nom is not None:
        logging.error("%s %s already exists", name, year)
        return NominationDto.from_model(existing_nom)

    nomination = Nomination(name=name, year=int(year))
    logging.info("Adding Nomination: %s", nomination)
    db.session.add(nomination)
    db.session.commit()

    return NominationDto.from_model(nomination)


def create_movie_nomination(movie: MovieDto, nomination: NominationDto):
    movie_nomination = db.session.scalars(
        select(MovieNomination)
        .where(MovieNomination.movie_id == movie.id)
        .where(MovieNomination.nomination_id == nomination.id)
    ).one_or_none()
    if movie_nomination is not None:
        logging.warning("Nomination: %s already exists", movie_nomination)
        return MovieNominationDto.from_model(movie_nomination)

    movie_nomination = MovieNomination(movie.id, nomination.id)
    logging.info("Adding MovieNomination: %s", movie_nomination)
    db.session.add(movie_nomination)
    db.session.commit()

    return MovieNominationDto.from_model(movie_nomination)
