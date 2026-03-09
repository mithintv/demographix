"""Nomination ORM models."""

from __future__ import annotations

from sqlalchemy import UniqueConstraint

from api.data.model import db


class Nomination(db.Model):
    """A nomination."""

    __tablename__ = "nominations"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(25))
    year = db.Column(db.Integer)

    movies = db.relationship(
        "Movie", secondary="movie_nominations", back_populates="nominations"
    )

    def __repr__(self):
        return f"<Nomination id={self.id} name={self.name} year={self.year}>"


class MovieNomination(db.Model):
    """An association table for movies and their respective nominations."""

    __tablename__ = "movie_nominations"

    id = db.Column(db.Integer, primary_key=True)
    movie_id = db.Column(db.Integer, db.ForeignKey("movies.id"))
    nomination_id = db.Column(db.Integer, db.ForeignKey("nominations.id"))

    __table_args__ = (
        UniqueConstraint(
            "movie_id", "nomination_id", name="unique_movie_id_nomination_id"
        ),
    )

    def __repr__(self):
        return str.format(
            "<MovieNomination id={} movie_id={} nomination_id={}>",
            self.id,
            self.movie_id,
            self.nomination_id,
        )

    def to_dict(self):
        """Convert the MovieNomination class to a dictionary."""
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}
