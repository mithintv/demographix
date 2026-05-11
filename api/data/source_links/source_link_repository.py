from api.data.base import db
from api.data.source_links.source_link_model import SourceLink
from api.services.logging_service import get_logger
from sqlalchemy import select

logger = get_logger(__name__)


def upsert_source_link(source_id: int, link: str):
    """Upsert new SourceLink by source_id and link."""

    source_link = db.session.scalars(
        select(SourceLink)
        .where(SourceLink.source_id == source_id)
        .where(SourceLink.link == link)
    ).one_or_none()

    if source_link is None:
        source_link = SourceLink(link=link, source_id=source_id)
        db.session.add(source_link)
        db.session.commit()
        logger.info("Created SourceLink: %s", source_link)

    return source_link
