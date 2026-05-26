from __future__ import annotations

from api.data.base import db
from sqlalchemy import ForeignKey, Integer
from sqlalchemy.orm import Mapped, mapped_column


class CastRace(db.Model):
    """An association table to link cast members with their respective races."""

    __tablename__ = "cast_races"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    race_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("races.id"))
    cast_member_id: Mapped[int | None] = mapped_column(
        Integer, ForeignKey("cast_members.id")
    )

    def __init__(self, cast_member_id: int, race_id: int):
        self.cast_member_id = cast_member_id
        self.race_id = race_id

    def __repr__(self):
        return f"<CastRace race_id={self.race_id} cast_id={self.cast_member_id}>"
