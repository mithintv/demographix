from __future__ import annotations

from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from api.data.countries.country_model import Country
    from api.data.ethnicities.ethnicity_model import Ethnicity
    from api.data.regions.region_model import Region


class SubRegion(db.Model):
    """A subregion."""

    __tablename__ = "subregions"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(25))
    region_id: Mapped[int] = mapped_column(Integer, ForeignKey("regions.id"))

    region: Mapped[Region] = relationship("Region", back_populates="subregions")
    countries: Mapped[list[Country]] = relationship(
        "Country", back_populates="subregion"
    )
    ethnicities: Mapped[list[Ethnicity]] = relationship(
        "Ethnicity", back_populates="subregion"
    )

    def __init__(self, name: str, region_id: int):
        self.name = name
        self.region_id = region_id

    def __repr__(self):
        return f"<SubRegion id={self.id} name={self.name}>"
