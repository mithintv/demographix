from __future__ import annotations

from datetime import datetime
from typing import TYPE_CHECKING

from sqlalchemy import DateTime, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from api.data.base import db

if TYPE_CHECKING:
    from api.data.credits.credit_model import Credit
    from api.data.model import AlsoKnownAs, Country, Ethnicity, Gender, Race, SourceLink


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
    ethnicities: Mapped[list["CastEthnicity"]] = relationship(
        "CastEthnicity", uselist=True, back_populates="cast_member"
    )
    races: Mapped[list[Race]] = relationship(
        "Race", secondary="cast_races", uselist=True, back_populates="cast"
    )

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


class CastEthnicity(db.Model):
    """An association table to link cast members and their ethnicities."""

    __tablename__ = "cast_ethnicities"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    ethnicity_id: Mapped[int | None] = mapped_column(Integer, db.ForeignKey("ethnicities.id"))
    cast_member_id: Mapped[int | None] = mapped_column(Integer, db.ForeignKey("cast_members.id"))

    cast_member: Mapped[CastMember] = relationship("CastMember", back_populates="ethnicities")
    ethnicity: Mapped[Ethnicity] = relationship("Ethnicity", back_populates="cast_ethnicity")
    sources: Mapped[list[SourceLink]] = relationship(
        "SourceLink",
        secondary="cast_ethnicity_source_links",
        back_populates="cast_ethnicities",
    )

    def __repr__(self):
        return str.format(
            "<CastEthnicity ethnicity_id={} cast_member_id={}>",
            self.ethnicity_id,
            self.cast_member_id,
        )
