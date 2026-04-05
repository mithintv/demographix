"""Service for event operations."""

from api.data.base import db
from api.data.events.event_model import Event
from sqlalchemy import select


def query_events():
    """Return all events ordered by id."""
    return db.session.scalars(select(Event).order_by(Event.id)).all()
