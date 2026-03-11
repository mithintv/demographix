from dataclasses import dataclass
from typing import TypedDict

from pydantic import BaseModel

from api.data.movies.movie_dto import MovieDto
from api.data.nominations.nomination_model import MovieNomination, Nomination


@dataclass
class NominationDto:
    id: int
    name: str
    year: int
    movies: list[MovieDto]

    @classmethod
    def from_model(cls, nomination: Nomination):
        return cls(
            id=nomination.id,
            name=nomination.name,
            year=nomination.year,
            movies=[MovieDto.from_model(movie) for movie in nomination.movies],
        )


@dataclass
class MovieNominationDto:
    id: int
    movie_id: int
    nomination_id: int

    @classmethod
    def from_model(cls, movie_nomination: MovieNomination):
        return cls(
            id=movie_nomination.id,
            movie_id=movie_nomination.movie_id,
            nomination_id=movie_nomination.nomination_id,
        )


class CreateNominationRequest(BaseModel):
    name: str
    year: int


class CheckNominationRequest(BaseModel):
    name: str
    year: int


class ImdbNominee(TypedDict):
    won: bool
    primary: str | None


class ImdbCategory(TypedDict):
    category: str
    nominations: list[ImdbNominee]
