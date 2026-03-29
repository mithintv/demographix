from __future__ import annotations

from typing import TYPE_CHECKING

from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from api.data.base import db

if TYPE_CHECKING:
    from api.data.cast_members.cast_member_model import CastMember


class Gender(db.Model):
    """A gender."""

    __tablename__ = "genders"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(20))

    cast_member: Mapped[list[CastMember]] = relationship(
        "CastMember", back_populates="gender"
    )

    def __init__(self, name: str):
        self.name = name

    def __repr__(self):
        return f"<Gender id={self.id} name={self.name}>"
