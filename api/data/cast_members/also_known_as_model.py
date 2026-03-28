from __future__ import annotations

from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from api.data.cast_members.cast_member_model import CastMember


class AlsoKnownAs(db.Model):
    """Alternative names for cast members."""

    __tablename__ = "also_known_as"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(), nullable=False)
    cast_member_id: Mapped[int] = mapped_column(Integer, ForeignKey("cast_members.id"))

    cast_member: Mapped[CastMember] = relationship(
        "CastMember", back_populates="also_known_as"
    )

    def __repr__(self):
        return f"<AlsoKnownAs id={self.id} name={self.name} cast_member_id={self.cast_member_id}>"
