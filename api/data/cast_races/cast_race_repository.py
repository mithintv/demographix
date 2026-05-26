from api.data.base import db
from api.data.cast_races.cast_race_model import CastRace
from api.services.logging_service import get_logger
from sqlalchemy import select

logger = get_logger(__name__)


def upsert_cast_race(cast_member_id: int, race_id: int):
    """Upsert CastRace by cast_member_id and race_id."""

    cast_race = db.session.scalars(
        select(CastRace)
        .where(CastRace.cast_member_id == cast_member_id)
        .where(CastRace.race_id == race_id)
    ).one_or_none()

    if cast_race is None:
        cast_race = CastRace(
            cast_member_id=cast_member_id,
            race_id=race_id,
        )
        db.session.add(cast_race)
        db.session.commit()
        logger.info("Created CastRace: %s", cast_race)

    return cast_race
