"""Admin routes for data validity checking."""

from flask import Blueprint, abort, jsonify, request
from pydantic import ValidationError

from api.data.cast_members.cast_member_dto import CastMemberDto
from api.data.cast_members.cast_member_repository import query_cast_members
from api.data.nominations.nomination_dto import (
    CheckNominationRequest,
    NominationDto,
)
from api.data.nominations.nomination_repository import (
    query_nominations,
)
from api.services.logging_service import get_logger
from api.services.nomination_service import check_nominations

logger = get_logger(__name__)

bp = Blueprint("admin", __name__, url_prefix="/admin")


@bp.route("/cast")
def get_cast():
    """Return paginated cast members with their demographic data."""
    search = request.args.get("search", None)
    if search is not None:
        search = search.strip() or None
    page = request.args.get("page", 1, type=int)
    per_page = request.args.get("per_page", 50, type=int)

    cast_members, total = query_cast_members(search, page, per_page)
    results = [CastMemberDto.from_model(cm) for cm in cast_members]
    return jsonify(
        {"cast": results, "total": total, "page": page, "per_page": per_page}
    )


@bp.route("/nominations")
def get_nominations():
    """Return nominations by imdb_event_id, with their associated movies."""
    imdb_event_id = request.args.get("imdb_event_id", None)
    if imdb_event_id is not None:
        imdb_event_id = imdb_event_id.strip()
    nominations = query_nominations(imdb_event_id)
    results = [NominationDto.from_model(nom) for nom in nominations]
    return jsonify({"nominations": results, "total": len(results)})


@bp.route("/nominations/check", methods=["POST"])
def post_nomination_check():
    """Check a nomination."""
    try:
        data = CheckNominationRequest.model_validate(request.get_json(silent=True))
    except ValidationError as e:
        abort(400, e.errors())
    check_nominations(data.name, data.year)
    return ("", 200)
