from __future__ import annotations

from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from api.data.countries.country_model import Country


class AltCountry(db.Model):
    """An association table for alternate ways to denote a country."""

    __tablename__ = "alt_countries"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    country_id: Mapped[int] = mapped_column(Integer, ForeignKey("countries.id"))
    alt_name: Mapped[str] = mapped_column(String(75))

    country: Mapped[list[Country]] = relationship(
        "Country", uselist=False, back_populates="alt_names"
    )

    def __init__(self, country_id: int, alt_name: str):
        self.country_id = country_id
        self.alt_name = alt_name

    def __repr__(self):
        return f"<AltCountry id={self.id} country_id={self.country_id}> alt_name={self.alt_name}"
