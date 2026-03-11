from datetime import datetime

from sqlalchemy import BigInteger, DateTime, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from api.data.model import db


class Movie(db.Model):
    """A movie."""

    __tablename__ = "movies"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    imdb_id: Mapped[str] = mapped_column(String(15))
    title: Mapped[str] = mapped_column(String(255))
    overview: Mapped[str] = mapped_column(String)
    runtime: Mapped[int] = mapped_column(Integer)
    poster_path: Mapped[str] = mapped_column(String)
    release_date: Mapped[datetime | None] = mapped_column(DateTime)
    budget: Mapped[int] = mapped_column(BigInteger)
    revenue: Mapped[int] = mapped_column(BigInteger)

    genres: Mapped[list] = relationship(
        "Genre", secondary="media_genres", uselist=True, back_populates="movies"
    )
    credits: Mapped[list] = relationship("Credit", back_populates="movie")
    nominations: Mapped[list] = relationship(
        "Nomination", secondary="movie_nominations", back_populates="movies"
    )

    def __init__(
        self,
        id: int,
        imdb_id: str,
        title: str,
        overview: str,
        runtime: int,
        poster_path: str,
        release_date: datetime | None,
        budget: int,
        revenue: int,
    ):
        self.id = id
        self.imdb_id = imdb_id
        self.title = title
        self.overview = overview
        self.runtime = runtime
        self.poster_path = poster_path
        self.release_date = release_date
        self.budget = budget
        self.revenue = revenue

    def __repr__(self):
        return (
            f"<Movie id={self.id} title={self.title} release_date={self.release_date}>"
        )

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "imdb_id": self.imdb_id,
            "title": self.title,
            "overview": self.overview,
            "runtime": self.runtime,
            "poster_path": self.poster_path,
            "release_date": (
                self.release_date.isoformat() if self.release_date else None
            ),
            "budget": self.budget,
            "revenue": self.revenue,
        }
