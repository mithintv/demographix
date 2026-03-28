from __future__ import annotations

from datetime import datetime
from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import DateTime, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from api.data.cast_members.also_known_as_model import AlsoKnownAs
    from api.data.cast_ethnicities.cast_ethnicity_model import CastEthnicity
    from api.data.countries.country_model import Country
    from api.data.credits.credit_model import Credit
    from api.data.genders.gender_model import Gender
    from api.data.races.race_model import Race


class CastMember(db.Model):
    """A cast member."""

    __tablename__ = "cast_members"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    imdb_id: Mapped[str | None] = mapped_column(String(15))
    name: Mapped[str] = mapped_column(String(50), nullable=False)
    gender_id: Mapped[int] = mapped_column(
        Integer, db.ForeignKey("genders.id"), nullable=False
    )
    birthday: Mapped[datetime | None] = mapped_column(DateTime)
    deathday: Mapped[datetime | None] = mapped_column(DateTime)
    biography: Mapped[str | None] = mapped_column(String())
    country_of_birth_id: Mapped[str | None] = mapped_column(
        String(3), db.ForeignKey("countries.id")
    )
    profile_path: Mapped[str | None] = mapped_column(String(35))

    also_known_as: Mapped[list[AlsoKnownAs]] = relationship(
        "AlsoKnownAs", uselist=True, back_populates="cast_member"
    )
    gender: Mapped[Gender] = relationship("Gender", back_populates="cast_member")
    country_of_birth: Mapped[Country | None] = relationship(
        "Country", back_populates="births"
    )
    credits: Mapped[list[Credit]] = relationship("Credit", back_populates="cast_member")
    ethnicities: Mapped[list[CastEthnicity]] = relationship(
        "CastEthnicity", uselist=True, back_populates="cast_member"
    )
    races: Mapped[list[Race]] = relationship(
        "Race", secondary="cast_races", uselist=True, back_populates="cast"
    )

    def __init__(
        self,
        id: int,
        imdb_id: str,
        name: str,
        gender_id: int,
        birthday: datetime | None,
        deathday: datetime | None,
        biography: str,
        country_of_birth_id: str | None,
        profile_path: str,
    ):
        self.id = id
        self.imdb_id = imdb_id
        self.name = name
        self.gender_id = gender_id
        self.birthday = birthday
        self.deathday = deathday
        self.biography = biography
        self.country_of_birth_id = country_of_birth_id
        self.profile_path = profile_path

    def __repr__(self):
        return f"<Cast id={self.id} name={self.name}>"

    def to_dict(self):
        """Convert the CastMember class to a dictionary."""
        return {
            "id": self.id,
            "imdb_id": self.imdb_id,
            "name": self.name,
            "gender_id": self.gender_id,
            "birthday": self.birthday,
            "deathday": self.deathday,
            "biography": self.biography,
            "country_of_birth_id": self.country_of_birth_id,
            "profile_path": self.profile_path,
        }
