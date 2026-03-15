from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from typing import Optional

from pydantic import BaseModel

from api.data.cast_members.cast_member_dto import CastMemberCreditDto
from api.data.genres.genre_dto import GenreDto
from api.data.movies.movie_model import Movie
from api.services.tmdb.tmdb_service import TmdbMovieDetails


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


@dataclass
class MovieDetailsDto:
    id: int
    imdb_id: str
    title: str
    release_date: datetime | None
    genres: list[str]
    budget: int
    overview: str
    poster_path: str
    runtime: int
    cast: list[CastMemberCreditDto]

    def __repr__(self):
        return f"<MovieDetails id={self.id} title={self.title} release_date={self.release_date} genres={self.genres}>"

    @classmethod
    def from_model(
        cls, movie: Movie, genres: list[str], cast: list[CastMemberCreditDto]
    ) -> MovieDetailsDto:
        return cls(
            id=movie.id,
            imdb_id=movie.imdb_id,
            title=movie.title,
            release_date=movie.release_date,
            budget=movie.budget,
            overview=movie.overview,
            poster_path=movie.poster_path,
            runtime=movie.runtime,
            genres=genres,
            cast=cast,
        )


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
    genres: list[GenreDto]

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
            genres=[
                GenreDto(id=g["id"], name=g["name"]) for g in data["genres"] if g["id"]
            ],
        )
