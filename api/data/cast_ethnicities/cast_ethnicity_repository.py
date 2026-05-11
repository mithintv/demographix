from api.data.base import db
from api.data.cast_ethnicities.cast_ethnicity_model import CastEthnicity
from api.services.logging_service import get_logger
from sqlalchemy import select

logger = get_logger(__name__)


def upsert_cast_ethnicity(cast_member_id: int, ethnicity_id: int):
    """Upsert Cast Ethnicity by cast_member_id and ethnicity_id."""

    cast_ethnicity = db.session.scalars(
        select(CastEthnicity)
        .where(CastEthnicity.cast_member_id == cast_member_id)
        .where(CastEthnicity.ethnicity_id == ethnicity_id)
    ).one_or_none()

    if cast_ethnicity is None:
        cast_ethnicity = CastEthnicity(
            cast_member_id=cast_member_id,
            ethnicity_id=ethnicity_id,
        )
        db.session.add(cast_ethnicity)
        db.session.commit()
        logger.info("Created CastEthnicity: %s", cast_ethnicity)

    return cast_ethnicity
