from sqlalchemy import select

from api.data.base import db
from api.data.cast_members.cast_member_repository import (
    add_ethnicity_data,
    add_race_data,
    find_cast_member_by_id,
)
from api.data.credits.credit_model import Credit
from api.services.ethnicelebs.ethniceleb_service import check_ethnicelebs
from api.services.logging_service import get_logger
from api.services.wikipedia.wikipedia_service import check_wikipedia

logger = get_logger(__name__)


def check_cast_member(cast_member_id: int):
    cast_member = find_cast_member_by_id(cast_member_id)
    if cast_member is None:
        return False

    ethnicities = check_ethnicelebs(cast_member.name)
    if ethnicities is None and cast_member.birthday:
        birthday_str = cast_member.birthday.strftime("%Y-%m-%d")
        ethnicities = check_wikipedia(cast_member.name, birthday_str)
    if ethnicities is None:
        return False

    add_ethnicity_data(cast_member, ethnicities)
    add_race_data(cast_member)
    return True


def check_movie_cast(movie_id: int, min_order: int = 10):
    """Check demographics for all cast members of a movie."""
    credits = db.session.scalars(
        select(Credit).where(Credit.movie_id == movie_id, Credit.order <= min_order)
    ).all()
    if not credits:
        return False

    for credit in credits:
        logger.info(
            "Checking cast member %s (order %s) for movie %s",
            credit.cast_member_id,
            credit.order,
            movie_id,
        )
        check_cast_member(credit.cast_member_id)
    return True
