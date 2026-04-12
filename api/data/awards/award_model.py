"""Award ORM model."""

from __future__ import annotations

from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import Integer, String, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from api.data.events.event_model import Event
    from api.data.nominations.nomination_model import Nomination


class Award(db.Model):
    """An award category within an event (e.g. Best Picture)."""

    __tablename__ = "awards"
    __table_args__ = (
        UniqueConstraint("event_id", "name", name="uq_awards_event_id_name"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    event_id: Mapped[int] = mapped_column(Integer, db.ForeignKey("events.id"))
    name: Mapped[str] = mapped_column(String(50))

    event: Mapped[Event] = relationship("Event", back_populates="awards")
    nominations: Mapped[list[Nomination]] = relationship(
        "Nomination", back_populates="award"
    )

    def __init__(self, event_id: int, name: str):
        self.event_id = event_id
        self.name = name

    def __repr__(self):
        return f"<Award id={self.id} event_id={self.event_id} name={self.name}>"

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "event": {
                "id": self.event_id,
                "name": self.event.name,
                "imdb_event_id": self.event.imdb_event_id,
            },
        }
