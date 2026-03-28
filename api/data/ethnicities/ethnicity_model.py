from __future__ import annotations

from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from api.data.alt_ethnicities.alt_ethnicity_model import AltEthnicity
    from api.data.cast_ethnicities.cast_ethnicity_model import CastEthnicity
    from api.data.regions.region_model import Region
    from api.data.sub_regions.sub_region_model import SubRegion


class Ethnicity(db.Model):
    """An ethnicity."""

    __tablename__ = "ethnicities"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(75), nullable=False)
    region_id: Mapped[int] = mapped_column(Integer, db.ForeignKey("regions.id"))
    subregion_id: Mapped[int] = mapped_column(Integer, db.ForeignKey("subregions.id"))

    alt_names: Mapped[list[AltEthnicity]] = relationship(
        "AltEthnicity", back_populates="ethnicity"
    )
    region: Mapped[list[Region]] = relationship("Region", back_populates="ethnicities")
    subregion: Mapped[list[SubRegion]] = relationship(
        "SubRegion", back_populates="ethnicities"
    )
    cast_ethnicity: Mapped[list[CastEthnicity]] = relationship(
        "CastEthnicity", back_populates="ethnicity"
    )

    def __repr__(self):
        return f"<Ethnicity id={self.id} name={self.name}>"
