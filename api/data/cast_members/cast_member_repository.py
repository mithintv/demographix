from datetime import datetime
from typing import TypedDict

from api.data.base import db
from api.data.cast_ethnicities.cast_ethnicity_model import CastEthnicity
from api.data.cast_ethnicities.cast_ethnicity_repository import upsert_cast_ethnicity
from api.data.cast_ethnicity_source_links.cast_ethnicity_source_link_repository import (
    upsert_cast_ethnicity_source_link,
)
from api.data.cast_members.cast_member_model import CastMember
from api.data.cast_races.cast_race_repository import upsert_cast_race
from api.data.countries.country_model import Country
from api.data.ethnicities.alt_ethnicity_model import AltEthnicity
from api.data.ethnicities.ethnicity_model import Ethnicity
from api.data.races.race_repository import get_race_by_short_name
from api.data.source_links.source_link_repository import upsert_source_link
from api.data.sources.source_repository import upsert_source
from api.services.logging_service import get_logger
from api.services.tmdb.tmdb_dto import TmdbPersonDetails
from sqlalchemy import func, or_, select
from sqlalchemy.orm import selectinload

logger = get_logger(__name__)


class CastEthnicityList(TypedDict):
    list: list[str]
    source: str


def query_cast_members(
    search: str | None = None,
    page: int = 1,
    per_page: int = 50,
) -> tuple[list[CastMember], int, int]:
    """Query cast members with their demographic data for the admin page."""
    stmt = (
        select(CastMember)
        .options(
            selectinload(CastMember.ethnicities).selectinload(CastEthnicity.ethnicity),
            selectinload(CastMember.ethnicities).selectinload(CastEthnicity.sources),
            selectinload(CastMember.races),
            selectinload(CastMember.gender),
            selectinload(CastMember.country_of_birth),
        )
        .order_by(CastMember.name)
    )

    count_stmt = select(func.count(CastMember.id))
    if search:
        stmt = stmt.where(func.lower(CastMember.name).like(f"%{search.lower()}%"))
        count_stmt = count_stmt.where(
            func.lower(CastMember.name).like(f"%{search.lower()}%")
        )

    total = db.session.scalar(count_stmt) or 0
    results = db.session.scalars(
        stmt.offset((page - 1) * per_page).limit(per_page)
    ).all()

    logger.info("Admin cast query: %d results (page %d)", total, page)
    return list(results), total, per_page


def find_cast_member_by_id(id: int):
    """Find a cast member by id."""
    cast_member = db.session.get(CastMember, id)
    if cast_member is None:
        logger.info("CastMember: %s not found", id)
        return None

    logger.info("%s found", cast_member)
    return cast_member


def create_cast_member(person_details: TmdbPersonDetails):
    """Create a cast member if one does not exist by TMDB person details."""
    cast_member = find_cast_member_by_id(person_details["id"])
    if cast_member is not None:
        logger.warning("%s already exists", cast_member)
        return cast_member

    country_of_birth = None
    place_of_birth = person_details.get("place_of_birth")
    if place_of_birth:
        country_name = place_of_birth.split(",")[-1].strip()
        country_of_birth = db.session.scalars(
            select(Country).where(Country.name == country_name)
        ).one_or_none()
    birthday_str = person_details.get("birthday")
    deathday_str = person_details.get("deathday")
    cast_member = CastMember(
        id=person_details["id"],
        imdb_id=person_details["imdb_id"],
        name=person_details["name"],
        gender_id=person_details["gender"],
        birthday=datetime.strptime(birthday_str, "%Y-%m-%d") if birthday_str else None,
        deathday=datetime.strptime(deathday_str, "%Y-%m-%d") if deathday_str else None,
        biography=person_details.get("biography"),
        country_of_birth_id=country_of_birth.id if country_of_birth else None,
        profile_path=person_details.get("profile_path"),
    )
    db.session.add(cast_member)
    db.session.commit()
    logger.info("Created CastMember: %s", cast_member)
    return cast_member


def add_ethnicity_data(cast_member: CastMember, ethnicity_results: CastEthnicityList):
    """Add ethnicity data for a cast member."""

    logger.info("Adding ethnicity data for %s", cast_member.name)
    if ethnicity_results.get("list", None) is None:
        logger.info("No ethnicity information found...")
        return

    ethnicity_list = ethnicity_results["list"]
    link = ethnicity_results["source"]
    for ethnicity_name in ethnicity_list:
        ethnicity = db.session.scalars(
            select(Ethnicity).where(
                or_(
                    Ethnicity.name == ethnicity_name,
                    Ethnicity.id.in_(
                        select(AltEthnicity.ethnicity_id).where(
                            AltEthnicity.alt_name == ethnicity_name
                        )
                    ),
                )
            )
        ).one_or_none()

        if ethnicity is None:
            logger.warning("Ethnicity %s not found", ethnicity_name)
            continue

        cast_ethnicity = upsert_cast_ethnicity(cast_member.id, ethnicity.id)
        source = upsert_source(link)
        source_link = upsert_source_link(source.id, link)
        upsert_cast_ethnicity_source_link(source_link.id, cast_ethnicity.id)


def add_race_data(cast_member: CastMember):
    """Add race data for a cast member."""

    logger.info("Adding approximate race data for %s", cast_member.name)
    if len(cast_member.ethnicities) == 0:
        logger.warning("Cannot approximate race data without ethnicity data")
        return

    cast_race_ids: set[int] = set()
    for cast_ethnicity in cast_member.ethnicities:
        logger.info("Checking %s", cast_ethnicity.ethnicity.name)

        # Direct race
        if cast_ethnicity.ethnicity.name == "African American":
            black = get_race_by_short_name("BLK")
            if black is not None:
                cast_race_ids.add(black.id)

        # Approximate race by demonym
        approx_countries = db.session.scalars(
            select(Country).where(Country.demonym == cast_ethnicity.ethnicity.name)
        ).all()
        if len(approx_countries) > 1:
            logger.warning(
                "Demonym %s has multiple countries %s",
                cast_ethnicity.ethnicity.name,
                approx_countries,
            )

        if len(approx_countries) == 1:
            approx_country = approx_countries[0]
            if approx_country is not None:
                logger.info(
                    "%s is approximately in %s, %s, %s",
                    cast_ethnicity.ethnicity.name,
                    approx_country.name,
                    approx_country.subregion.name,
                    approx_country.region.name,
                )
                if approx_country.name == "Guyana":
                    continue

                if approx_country.region.name == "Europe":
                    white = get_race_by_short_name("WHT")
                    if white is not None:
                        cast_race_ids.add(white.id)

                if approx_country.subregion.name in [
                    "Central Asia",
                    "Western Asia",
                ]:
                    mena = get_race_by_short_name("MENA")
                    if mena is not None:
                        cast_race_ids.add(mena.id)

                if approx_country.region.name == "Africa" or approx_country.name in [
                    "Haiti",
                    "Dominican Republic",
                    "Trinidad and Tobago",
                ]:
                    black = get_race_by_short_name("BLK")
                    if black is not None:
                        cast_race_ids.add(black.id)

                if approx_country.subregion.name in [
                    "Central America",
                    "South America",
                ] or approx_country.name in [
                    "Mexico",
                    "Puerto Rico",
                    "Cuba",
                    "Dominican Republic",
                ]:
                    hispanic = get_race_by_short_name("HSPN")
                    if hispanic is not None:
                        cast_race_ids.add(hispanic.id)

                if approx_country.subregion.name in [
                    "Eastern Asia",
                    "South-Eastern Asia",
                    "Southern Asia",
                ]:
                    asian = get_race_by_short_name("ASN")
                    if asian is not None:
                        cast_race_ids.add(asian.id)

                if approx_country.subregion.name in [
                    "Polynesia",
                    "Micronesia",
                    "Melanesia",
                ]:
                    nhpi = get_race_by_short_name("NHPI")
                    if nhpi is not None:
                        cast_race_ids.add(nhpi.id)

            else:
                logger.info(
                    "Could not associate %s with a country",
                    cast_ethnicity.ethnicity.name,
                )
                if cast_ethnicity.ethnicity.name in [
                    "English",
                    "Cornish",
                    "Scottish",
                    "Welsh",
                    "Jewish",
                ]:
                    white = get_race_by_short_name("WHT")
                    if white is not None:
                        cast_race_ids.add(white.id)

                if cast_ethnicity.ethnicity.name in [
                    "African American",
                    "African",
                    "Guyanese",
                ]:
                    black = get_race_by_short_name("BLK")
                    if black is not None:
                        cast_race_ids.add(black.id)

                if cast_ethnicity.ethnicity.name in ["Korean"]:
                    asian = get_race_by_short_name("ASN")
                    if asian is not None:
                        cast_race_ids.add(asian.id)

                if cast_ethnicity.ethnicity.name == "Hawaiian":
                    nhpi = get_race_by_short_name("NHPI")
                    if nhpi is not None:
                        cast_race_ids.add(nhpi.id)

    for race_id in cast_race_ids:
        upsert_cast_race(cast_member.id, race_id)
