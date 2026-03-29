from __future__ import annotations

from dataclasses import dataclass
from typing import TYPE_CHECKING

from api.data.cast_ethnicities.cast_ethnicity_model import CastEthnicity
from api.data.source_links.source_link_model import SourceLink

if TYPE_CHECKING:
    from api.data.cast_members.cast_member_model import CastMember


@dataclass
class SourceLinkDto:
    id: int
    link: str
    source_id: int

    @classmethod
    def from_model(cls, source_link: SourceLink):
        return SourceLinkDto(
            id=source_link.id, link=source_link.link, source_id=source_link.source_id
        )


@dataclass
class CastEthnicityDto:
    name: str
    sources: list[SourceLinkDto]

    @classmethod
    def from_model(cls, cast_ethnicity: CastEthnicity):
        return CastEthnicityDto(
            name=cast_ethnicity.ethnicity.name,
            sources=[
                SourceLinkDto.from_model(source) for source in cast_ethnicity.sources
            ],
        )


@dataclass
class CastMemberDto:
    id: int
    name: str
    gender: str
    country_of_birth: str | None
    ethnicities: list[CastEthnicityDto]
    races: list[str]

    @classmethod
    def from_model(cls, cast_member: CastMember) -> CastMemberDto:
        return CastMemberDto(
            id=cast_member.id,
            name=cast_member.name,
            gender=cast_member.gender.name,
            country_of_birth=(
                cast_member.country_of_birth.name
                if cast_member.country_of_birth
                else None
            ),
            ethnicities=[
                CastEthnicityDto.from_model(e) for e in cast_member.ethnicities
            ],
            races=[r.name for r in cast_member.races],
        )


@dataclass
class CastMemberCreditDto:
    id: int
    name: str
    birthday: str | None
    gender: str
    ethnicity: list[CastEthnicityDto]
    race: list[str]
    country_of_birth: int | None
    character: str
    order: int
    profile_path: str | None
