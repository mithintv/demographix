from __future__ import annotations

from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from api.data.ethnicities.ethnicity_model import Ethnicity


class AltEthnicity(db.Model):
    """An alternate name for an ethnicity."""

    __tablename__ = "alt_ethnicities"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    ethnicity_id: Mapped[int] = mapped_column(
        Integer, db.ForeignKey("ethnicities.id"), nullable=False
    )
    alt_name: Mapped[str] = mapped_column(String(75))

    ethnicity: Mapped[list[Ethnicity]] = relationship(
        "Ethnicity", uselist=False, back_populates="alt_names"
    )

    def __init__(self, ethnicity_id: int, alt_name: str):
        self.ethnicity_id = ethnicity_id
        self.alt_name = alt_name

    def __repr__(self):
        return (
            f"<AltEthnicity ethnicity_id={self.ethnicity_id} alt_name={self.alt_name}>"
        )
