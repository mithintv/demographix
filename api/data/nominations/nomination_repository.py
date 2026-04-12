from sqlalchemy import func, select

from api.data.awards.award_model import Award
from api.data.base import db
from api.data.events.event_model import Event
from api.data.movies.movie_model import Movie
from api.data.nominations.nomination_model import MovieNomination, Nomination
from api.services.logging_service import get_logger

logger = get_logger(__name__)


def query_nomination_years():
    nomination_years = db.session.scalars(
        select(Nomination.year)
        .distinct(Nomination.year)
        .order_by(Nomination.year.desc())
    ).all()
    return nomination_years


def query_nomination_awards(imdb_event_id: str | None = None):
    stmt = select(Award).join(Event)
    if imdb_event_id:
        stmt = stmt.where(
            func.lower(Event.imdb_event_id) == imdb_event_id.strip().lower()
        )
    nomination_awards = db.session.scalars(stmt.order_by(Award.id.asc())).all()
    return nomination_awards


def query_nomination_movies(imdb_event_id: str | None = None):
    stmt = select(Nomination).join(Award).join(Event)
    if imdb_event_id is not None:
        stmt = stmt.where(
            func.lower(Event.imdb_event_id) == imdb_event_id.strip().lower()
        )
    nominations = db.session.scalars(
        stmt.outerjoin(MovieNomination, MovieNomination.nomination_id == Nomination.id)
        .outerjoin(Movie, Movie.id == MovieNomination.movie_id)
        .distinct()
        .order_by(Nomination.year.desc())
    ).all()

    return [nomination for nomination in nominations]


def get_nominations_by_imdb_event_id_and_award_year(
    imdb_event_id: str,
    year: int,
    award_id: int | None = None,
):
    stmt = select(Nomination).join(Award).join(Event)
    if award_id is not None:
        stmt = stmt.where(Award.id == award_id)
    nominations = db.session.scalars(
        stmt.where(func.lower(Event.imdb_event_id) == imdb_event_id.lower()).where(
            Nomination.year == year
        )
    ).all()

    if len(nominations) == 0:
        logger.warn(
            "No Nominations found for Event: %s Year: %s Award ID: %s",
            imdb_event_id,
            year,
            award_id,
        )

    return nominations


def get_movie_nominations_by_nomination_id(nomination_id: int):
    movie_nominations = db.session.scalars(
        select(MovieNomination)
        .join(Movie, Movie.id == MovieNomination.movie_id)
        .where(MovieNomination.nomination_id == nomination_id)
    ).all()
    return movie_nominations


def create_nomination(award_id: int, year: int):
    """Create new nomination by award_id and nomination year"""
    existing_nom = db.session.scalars(
        select(Nomination)
        .where(Nomination.award_id == award_id)
        .where(Nomination.year == year)
    ).first()
    if existing_nom is not None:
        logger.error("Award ID: %s Year: %s already exists", award_id, year)
        return existing_nom

    nomination = Nomination(award_id, year)
    logger.info("Adding Nomination: %s", nomination)
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
        logger.warning("%s already exists", movie_nomination)
        return movie_nomination

    movie_nomination = MovieNomination(movie.id, nomination.id)
    logger.info("Adding MovieNomination: %s", movie_nomination)
    db.session.add(movie_nomination)
    db.session.commit()

    return movie_nomination
