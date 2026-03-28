from __future__ import annotations

from typing import TYPE_CHECKING

from api.data.base import db
from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

if TYPE_CHECKING:
    from api.data.source_links.source_link_model import SourceLink


class Source(db.Model):
    """A table listing demographic data sources."""

    __tablename__ = "sources"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[int] = mapped_column(String(25))
    domain: Mapped[int] = mapped_column(String())

    links: Mapped[list[SourceLink]] = relationship(
        "SourceLink", uselist=True, back_populates="source"
    )

    def __repr__(self):
        return f"<Source id={self.id} name={self.name} domain={self.domain}>"
