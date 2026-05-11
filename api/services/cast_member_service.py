from api.data.cast_members.cast_member_repository import add_ethnicity_data, add_race_data, find_cast_member_by_id
from api.services.ethnicelebs.ethniceleb_service import check_ethnicelebs


def check_cast_member(cast_member_id: int):
    cast_member = find_cast_member_by_id(cast_member_id)
    if cast_member is None:
        return False

    ethnicities = check_ethnicelebs(cast_member.name)
    if (ethnicities is None):
      return False

    add_ethnicity_data(cast_member, ethnicities)
    add_race_data(cast_member)
    return True
