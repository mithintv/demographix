from __future__ import annotations

from typing import TYPE_CHECKING

from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from api.data.base import db
from api.data.cast_members.cast_member_model import CastMember

if TYPE_CHECKING:
    from api.data.movies.movie_model import Movie


class Credit(db.Model):
    """A credit."""

    __tablename__ = "credits"

    id: Mapped[str] = mapped_column(String(), primary_key=True)
    movie_id: Mapped[int] = mapped_column(
        Integer, db.ForeignKey("movies.id"), nullable=False
    )
    character: Mapped[str] = mapped_column(String(75))
    order: Mapped[int] = mapped_column(Integer)
    cast_member_id: Mapped[int] = mapped_column(
        Integer, db.ForeignKey("cast_members.id"), nullable=False
    )

    movie: Mapped[Movie] = relationship(
        "Movie", uselist=False, back_populates="credits"
    )
    cast_member: Mapped[CastMember] = relationship(
        "CastMember", uselist=False, back_populates="credits"
    )

    def __init__(
        self,
        id: str,
        movie_id: int,
        character: str,
        order: int,
        cast_member_id: int,
    ):
        self.id = id
        self.movie_id = movie_id
        self.character = character
        self.order = order
        self.cast_member_id = cast_member_id

    def __repr__(self):
        return f"<Credit id={self.id} character={self.character}>"
