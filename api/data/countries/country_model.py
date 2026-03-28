from __future__ import annotations

from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from api.data.alt_country.alt_country_model import AltCountry
    from api.data.cast_members.cast_member_model import CastMember
    from api.data.regions.region_model import Region
    from api.data.sub_regions.sub_region_model import SubRegion


class Country(db.Model):
    """A country."""

    __tablename__ = "countries"

    id: Mapped[str] = mapped_column(String(3), primary_key=True)
    name: Mapped[str] = mapped_column(String(75), nullable=False)
    demonym: Mapped[str] = mapped_column(String(75))
    region_id: Mapped[int] = mapped_column(
        Integer, ForeignKey("regions.id"), nullable=False
    )
    subregion_id: Mapped[int] = mapped_column(
        Integer, ForeignKey("subregions.id"), nullable=False
    )

    alt_names: Mapped[list[AltCountry]] = relationship(
        "AltCountry", back_populates="country"
    )
    region: Mapped[list[Region]] = relationship("Region", back_populates="countries")
    subregion: Mapped[list[SubRegion]] = relationship(
        "SubRegion", back_populates="countries"
    )
    births: Mapped[list[CastMember]] = relationship(
        "CastMember", back_populates="country_of_birth"
    )

    def __repr__(self):
        return f"<Country id={self.id} name={self.name} demonym={self.demonym}>"
