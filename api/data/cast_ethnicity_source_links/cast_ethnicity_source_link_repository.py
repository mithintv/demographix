from api.data.base import db
from api.data.cast_ethnicity_source_links.cast_ethnicity_source_link_model import (
    CastEthnicitySourceLink,
)
from api.services.logging_service import get_logger
from sqlalchemy import select

logger = get_logger(__name__)


def upsert_cast_ethnicity_source_link(source_link_id: int, cast_ethnicity_id: int):
    """Upsert CastEthncitySourceLink by source_link_id and cast_ethnicity_id."""

    cast_ethnicity_source_link = db.session.scalars(
        select(CastEthnicitySourceLink)
        .where(CastEthnicitySourceLink.source_link_id == source_link_id)
        .where(CastEthnicitySourceLink.cast_ethnicity_id == cast_ethnicity_id)
    ).one_or_none()

    if cast_ethnicity_source_link is None:
        cast_ethnicity_source_link = CastEthnicitySourceLink(
            source_link_id=source_link_id,
            cast_ethnicity_id=cast_ethnicity_id,
        )
        db.session.add(cast_ethnicity_source_link)
        db.session.commit()
        logger.info("Created CastEthnicitySourceLink: %s", cast_ethnicity_source_link)

    return cast_ethnicity_source_link
