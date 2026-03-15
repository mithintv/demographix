import logging

from sqlalchemy import select

from api.data.base import db
from api.data.cast_members.cast_member_model import CastMember
from api.data.credits.credit_model import Credit
from api.services.tmdb.tmdb_dto import TmdbMovieCredits


def create_credits(tmdb_credits: TmdbMovieCredits):
    """Create credits for a movie from TMDB cast data."""
    for credit in tmdb_credits["cast"]:
        existing_credit = db.session.scalars(
            select(Credit).where(Credit.id == credit["credit_id"])
        ).one_or_none()
        if existing_credit is not None:
            logging.warning("%s already exists", existing_credit)
            continue

        cast_member = db.session.scalars(
            select(CastMember).where(CastMember.id == credit["id"])
        ).one_or_none
        if cast_member is None:
            logging.error(
                "CastMember: %s doesn't exist. Cannot add Credit: %s",
                credit["id"],
                credit["credit_id"],
            )
            continue

        new_credit = Credit(
            id=credit["credit_id"],
            movie_id=tmdb_credits["id"],
            character=credit["character"],
            order=credit["order"],
            cast_member_id=credit["id"],
        )
        db.session.add(new_credit)
        logging.info("Adding %s", new_credit)
    db.session.commit()
