"""Event ORM model."""

from __future__ import annotations

from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from api.data.awards.award_model import Award


class Event(db.Model):
    """An awards event (e.g. Academy Awards, Golden Globes)."""

    __tablename__ = "events"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(25), unique=True)
    imdb_event_id: Mapped[str] = mapped_column(String(10), unique=True)

    awards: Mapped[list[Award]] = relationship("Award", back_populates="event")

    def __init__(self, name: str, imdb_event_id: str):
        self.name = name
        self.imdb_event_id = imdb_event_id

    def __repr__(self):
        return f"<Event id={self.id} name={self.name}>"

    def to_dict(self):
        return {"id": self.id, "name": self.name}
