from dataclasses import dataclass

from api.data.genres.genre_model import Genre


@dataclass
class GenreDto:
    id: int
    name: str

    @classmethod
    def from_model(cls, genre: Genre):
        return cls(id=genre.id, name=genre.name)
