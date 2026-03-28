from __future__ import annotations

from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import ForeignKey, Integer
from sqlalchemy.orm import Mapped, mapped_column

if TYPE_CHECKING:
    pass


class CastEthnicitySourceLink(db.Model):
    """An association table for cast ethnicities and the source links they are retrieved from."""

    __tablename__ = "cast_ethnicity_source_links"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    source_link_id: Mapped[int] = mapped_column(Integer, ForeignKey("source_links.id"))
    cast_ethnicity_id: Mapped[int] = mapped_column(
        Integer, ForeignKey("cast_ethnicities.id")
    )

    def __repr__(self):
        return str.format(
            "<CastEthnicitySourceLink id={} source_link_id={} cast_ethnicity_id={}>",
            self.id,
            self.source_link_id,
            self.cast_ethnicity_id,
        )
