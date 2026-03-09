from dataclasses import dataclass


@dataclass
class NominationMovieDTO:
    id: int
    title: str
    release_date: str
    has_cast: bool


@dataclass
class NominationDTO:
    id: int
    name: str
    year: int
    movies: list[NominationMovieDTO]
