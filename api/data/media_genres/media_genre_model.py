from api.data.base import db
from sqlalchemy import ForeignKey, Integer
from sqlalchemy.orm import Mapped, mapped_column


class MediaGenre(db.Model):
    """An association table for different media and their genres."""

    __tablename__ = "media_genres"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    genre_id: Mapped[int] = mapped_column(Integer, ForeignKey("genres.id"))
    movie_id: Mapped[int] = mapped_column(Integer, ForeignKey("movies.id"))

    def __repr__(self):
        return f"<MediaGenre genre_id={self.genre_id} movie_id={self.movie_id}>"
