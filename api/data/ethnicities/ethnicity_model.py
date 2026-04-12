from __future__ import annotations

from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from api.data.ethnicities.alt_ethnicity_model import AltEthnicity
    from api.data.cast_ethnicities.cast_ethnicity_model import CastEthnicity
    from api.data.subregions.subregion_model import SubRegion


class Ethnicity(db.Model):
    """An ethnicity."""

    __tablename__ = "ethnicities"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(75), nullable=False, unique=True)
    subregion_id: Mapped[int | None] = mapped_column(
        Integer, db.ForeignKey("subregions.id")
    )

    alt_names: Mapped[list[AltEthnicity]] = relationship(
        "AltEthnicity", back_populates="ethnicity"
    )
    subregion: Mapped[list[SubRegion]] = relationship(
        "SubRegion", back_populates="ethnicities"
    )
    cast_ethnicity: Mapped[list[CastEthnicity]] = relationship(
        "CastEthnicity", back_populates="ethnicity"
    )

    def __init__(self, name: str, subregion_id: int | None = None):
        self.name = name
        self.subregion_id = subregion_id

    def __repr__(self):
        return f"<Ethnicity id={self.id} name={self.name} subregion_id={self.subregion_id}>"
