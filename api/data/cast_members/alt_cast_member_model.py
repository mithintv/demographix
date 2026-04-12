from __future__ import annotations

from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import ForeignKey, Integer, String, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from api.data.cast_members.cast_member_model import CastMember


class AltCastMember(db.Model):
    """Alternative names for cast members."""

    __tablename__ = "alt_cast_members"
    __table_args__ = (
        UniqueConstraint(
            "cast_member_id",
            "alt_name",
            name="uq_alt_cast_members_cast_member_id_alt_name",
        ),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    cast_member_id: Mapped[int] = mapped_column(Integer, ForeignKey("cast_members.id"))
    alt_name: Mapped[str] = mapped_column(String(), nullable=False)

    cast_member: Mapped[CastMember] = relationship(
        "CastMember", back_populates="alt_names"
    )

    def __repr__(self):
        return f"<AltCastMember cast_member_id={self.cast_member_id} alt_name={self.alt_name}>"
