from __future__ import annotations

from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import Integer
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from api.data.cast_members.cast_member_model import CastMember
    from api.data.ethnicities.ethnicity_model import Ethnicity
    from api.data.source_links.source_link_model import SourceLink


class CastEthnicity(db.Model):
    """An association table to link cast members and their ethnicities."""

    __tablename__ = "cast_ethnicities"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    ethnicity_id: Mapped[int | None] = mapped_column(
        Integer, db.ForeignKey("ethnicities.id")
    )
    cast_member_id: Mapped[int | None] = mapped_column(
        Integer, db.ForeignKey("cast_members.id")
    )

    cast_member: Mapped[CastMember] = relationship(
        "CastMember", back_populates="ethnicities"
    )
    ethnicity: Mapped[Ethnicity] = relationship(
        "Ethnicity", back_populates="cast_ethnicity"
    )
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
