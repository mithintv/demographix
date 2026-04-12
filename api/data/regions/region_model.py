from __future__ import annotations

from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from api.data.countries.country_model import Country
    from api.data.subregions.subregion_model import SubRegion


class Region(db.Model):
    """A region."""

    __tablename__ = "regions"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(15), unique=True)

    subregions: Mapped[list[SubRegion]] = relationship(
        "SubRegion", back_populates="region"
    )
    countries: Mapped[list[Country]] = relationship("Country", back_populates="region")

    def __init__(self, name: str):
        self.name = name

    def __repr__(self):
        return f"<Region id={self.id} name={self.name}>"
