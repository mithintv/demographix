"""Nomination ORM models."""

from __future__ import annotations

from typing import TYPE_CHECKING

from sqlalchemy import Integer, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from api.data.base import db

if TYPE_CHECKING:
    from api.data.awards.award_model import Award
    from api.data.movies.movie_model import Movie


class Nomination(db.Model):
    """A nomination for a specific award in a given year."""

    __tablename__ = "nominations"
    __table_args__ = (
        UniqueConstraint("award_id", "year", name="uq_nominations_award_id_year"),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    award_id: Mapped[int] = mapped_column(Integer, db.ForeignKey("awards.id"))
    year: Mapped[int] = mapped_column(Integer)

    award: Mapped[Award] = relationship("Award", back_populates="nominations")
    movies: Mapped[list[Movie]] = relationship(
        "Movie", secondary="movie_nominations", back_populates="nominations"
    )

    def __init__(self, award_id: int, year: int):
        self.award_id = award_id
        self.year = year

    def __repr__(self):
        return f"<Nomination id={self.id} award_id={self.award_id} year={self.year}>"

    def to_dict(self):
        return {
            "id": self.id,
            "award_id": self.award_id,
            "award": self.award.name,
            "year": self.year,
            "movies": self.movies,
        }


class MovieNomination(db.Model):
    """An association table for movies and their respective nominations."""

    __tablename__ = "movie_nominations"
    __table_args__ = (
        UniqueConstraint(
            "movie_id",
            "nomination_id",
            name="uq_movie_nominations_movie_id",
        ),
    )

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    movie_id: Mapped[int] = mapped_column(Integer, db.ForeignKey("movies.id"))
    nomination_id: Mapped[int] = mapped_column(Integer, db.ForeignKey("nominations.id"))

    def __init__(self, movie_id: int, nomination_id: int):
        self.movie_id = movie_id
        self.nomination_id = nomination_id

    def __repr__(self):
        return str.format(
            "<MovieNomination id={} movie_id={} nomination_id={}>",
            self.id,
            self.movie_id,
            self.nomination_id,
        )

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "movie_id": self.movie_id,
            "nomination_id": self.nomination_id,
        }
