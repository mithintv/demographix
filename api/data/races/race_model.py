from __future__ import annotations

from typing import TYPE_CHECKING

from sqlalchemy import ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from api.data.base import db

if TYPE_CHECKING:
    from api.data.cast_members.cast_member_model import CastMember


class Race(db.Model):
    """A race according to the US Census."""

    __tablename__ = "races"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(75))
    short: Mapped[str] = mapped_column(String(5), unique=True)
    description: Mapped[str] = mapped_column(String())

    cast: Mapped[list[CastMember]] = relationship(
        "CastMember", secondary="cast_races", back_populates="races"
    )

    def __init__(self, name: str, short: str, description: str):
        self.name = name
        self.short = short
        self.description = description

    def __repr__(self):
        return f"<Race race_id={self.id} name={self.name} short={self.short}>"


class CastRace(db.Model):
    """An association table to link cast members with their respective races."""

    __tablename__ = "cast_races"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    race_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("races.id"))
    cast_member_id: Mapped[int | None] = mapped_column(
        Integer, ForeignKey("cast_members.id")
    )

    def __repr__(self):
        return f"<CastRace race_id={self.race_id} cast_id={self.cast_member_id}>"
