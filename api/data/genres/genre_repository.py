import logging

from sqlalchemy import select

from api.data.genres.genre_model import Genre
from api.data.model import db


def get_genre_by_id(id: int):
    """Get genre by id"""
    genre = db.session.scalars(select(Genre).where(Genre.id == id)).one_or_none()
    if genre is not None:
        logging.info("Genre: %s found!", genre)

    return genre


def create_genre(id: int, name: str, delay_commit: bool = False):
    """Create a new genre in the database."""
    existing_genre = db.session.scalars(
        select(Genre).where(Genre.id == id)
    ).one_or_none()
    if existing_genre is not None:
        logging.warning("Genre: %s already exists!", existing_genre)
        return existing_genre

    genre = Genre(id=id, name=name)
    logging.info("Adding Genre: %s", genre)
    db.session.add(genre)
    if delay_commit is False:
        db.session.commit()
    return genre
