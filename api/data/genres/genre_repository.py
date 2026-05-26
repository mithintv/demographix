from sqlalchemy import select

from api.data.base import db
from api.data.genres.genre_model import Genre
from api.services.logging_service import get_logger

logger = get_logger(__name__)


def get_genre_by_id(id: int):
    """Get genre by id"""
    genre = db.session.scalars(select(Genre).where(Genre.id == id)).one_or_none()
    if genre is not None:
        logger.info("Genre: %s found!", genre)
    return genre


def create_genre(id: int, name: str, delay_commit: bool = False):
    """Create a new genre in the database."""
    existing_genre = db.session.scalars(
        select(Genre).where(Genre.id == id)
    ).one_or_none()
    if existing_genre is not None:
        logger.warning("Genre: %s already exists!", existing_genre)
        return existing_genre

    genre = Genre(id=id, name=name)
    logger.info("Adding Genre: %s", genre)
    db.session.add(genre)
    if not delay_commit:
        db.session.commit()
    return genre
