from api.data.base import db
from api.data.sources.source_model import Source
from api.services.logging_service import get_logger
from sqlalchemy import select

logger = get_logger(__name__)


def upsert_source(source_link: str):
    """Upsert new Source by source_link."""

    formatted_source = "/".join(source_link.split("/")[0:3])
    source = db.session.scalars(
        select(Source).where(Source.domain.like(f"%{formatted_source}%"))
    ).one_or_none()

    if source is None:
        source = Source(
            name=formatted_source.split("//")[-1].split(".")[0].capitalize(),
            domain=f"{formatted_source}",
        )
        db.session.add(source)
        db.session.commit()
        logger.info("Created Source: %s", source)

    return source
