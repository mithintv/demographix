from __future__ import annotations

from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from api.data.cast_ethnicities.cast_ethnicity_model import CastEthnicity
    from api.data.sources.source_model import Source


class SourceLink(db.Model):
    """An association table for demographic data sources and the data they are providing."""

    __tablename__ = "source_links"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    source_id: Mapped[int] = mapped_column(Integer, db.ForeignKey("sources.id"))
    link: Mapped[str] = mapped_column(String())

    source: Mapped[list[Source]] = relationship("Source", back_populates="links")
    cast_ethnicities: Mapped[list[CastEthnicity]] = relationship(
        "CastEthnicity",
        secondary="cast_ethnicity_source_links",
        back_populates="sources",
    )

    def __repr__(self):
        return f"<SourceLink id={self.id} source_id={self.source_id} link={self.link}>"
