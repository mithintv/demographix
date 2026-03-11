from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from typing import Optional

from pydantic import BaseModel

from api.data.movies.movie_model import Movie
from api.services.tmdb_service import TmdbMovieDetails


@dataclass
class MovieDto:
    id: int
    title: str
    release_date: datetime | None

    def __repr__(self):
        return (
            f"<Movie id={self.id} title={self.title} release_date={self.release_date}>"
        )

    @classmethod
    def from_model(cls, movie: Movie) -> MovieDto:
        return cls(id=movie.id, title=movie.title, release_date=movie.release_date)


class CreateMovieRequest(BaseModel):
    id: int
    imdb_id: str
    title: str
    overview: str
    runtime: int
    poster_path: str
    release_date: Optional[str]
    budget: int
    revenue: int
    genre_ids: Optional[list[int]]

    @classmethod
    def from_tmdb(cls, data: TmdbMovieDetails) -> CreateMovieRequest:
        return cls(
            id=data["id"],
            imdb_id=data["imdb_id"],
            title=data["title"],
            overview=data["overview"],
            runtime=data["runtime"],
            poster_path=data["poster_path"],
            release_date=data["release_date"],
            budget=data["budget"],
            revenue=data["revenue"],
            genre_ids=[g["id"] for g in data["genres"]],
        )
