import logging
from datetime import datetime

from sqlalchemy import func, select
from sqlalchemy.orm import selectinload

from api.data.base import db
from api.data.cast_ethnicities.cast_ethnicity_model import CastEthnicity
from api.data.cast_members.cast_member_model import CastMember
from api.data.countries.country_model import Country
from api.services.tmdb.tmdb_dto import TmdbPersonDetails


def query_cast_members(
    search: str | None = None, page: int = 1, per_page: int = 50
) -> tuple[list[CastMember], int]:
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

    if search:
        stmt = stmt.where(func.lower(CastMember.name).like(f"%{search.lower()}%"))

    count_stmt = select(func.count(CastMember.id))
    if search:
        count_stmt = count_stmt.where(
            func.lower(CastMember.name).like(f"%{search.lower()}%")
        )

    total = db.session.scalar(count_stmt) or 0
    results = db.session.scalars(
        stmt.offset((page - 1) * per_page).limit(per_page)
    ).all()

    logging.info("Admin cast query: %d results (page %d)", total, page)
    return list(results), total


def find_cast_member_by_id(id: int):
    """Find a cast member by id."""
    cast_member = db.session.get(CastMember, id)
    if cast_member is None:
        logging.info("CastMember: %s not found", id)
        return None

    logging.info("%s found", cast_member)
    return cast_member


def create_cast_member(person_details: TmdbPersonDetails):
    """Create a cast member if one does not exist by TMDB person details."""
    cast_member = find_cast_member_by_id(person_details["id"])
    if cast_member is not None:
        logging.warning("%s already exists", cast_member)
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
    new_cast_member = CastMember(
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
    db.session.add(new_cast_member)
    db.session.commit()
    logging.info("Created CastMember: %s", new_cast_member)
    return cast_member
