from __future__ import annotations

from typing import TYPE_CHECKING

from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from api.data.base import db

if TYPE_CHECKING:
    from api.data.movies.movie_model import Movie


class Genre(db.Model):
    """A genre."""

    __tablename__ = "genres"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(15))

    movies: Mapped[list[Movie]] = relationship(
        "Movie", secondary="media_genres", back_populates="genres"
    )

    def __init__(self, id: int, name: str):
        self.id = id
        self.name = name

    def __repr__(self):
        return f"<Genre id={self.id} name={self.name}>"

    def to_dict(self):
        return {"id": self.id, "name": self.name}
