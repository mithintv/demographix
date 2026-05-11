from sqlalchemy import select

from api.data.base import db
from api.data.races.race_model import Race


def get_race_by_short_name(short_name: str):
    """Get Race by short name."""
    race = db.session.scalars(
        select(Race).where(Race.short == short_name)
    ).one_or_none()
    return race
