"""Admin routes for data validity checking."""

from flask import Blueprint, jsonify, request
from pydantic import ValidationError
from werkzeug.exceptions import BadRequest

from api.data.cast_members.cast_member_dto import CastMemberDto
from api.data.cast_members.cast_member_repository import query_cast_members
from api.data.nominations.nomination_dto import (
    CheckNominationRequest,
    CreateNominationRequest,
    DeleteMovieNominationRequest,
)
from api.data.nominations.nomination_repository import (
    create_nomination,
    delete_movie_nomination,
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


@bp.route("/nominations", methods=["POST"])
def post_nominations():
    """Create nomination by award_id and year."""
    try:
        data = CreateNominationRequest.model_validate(request.get_json(silent=True))
    except ValidationError as e:
        return jsonify({"errors": e.errors()}), 400
    nomination = create_nomination(data.award_id, data.year)
    return jsonify(nomination.to_dict())


@bp.route("/nominations/<int:id>/movies/<int:movie_id>", methods=["DELETE"])
def delete_movie_nominations(id: int, movie_id: int):
    """Delete movie nomination by nomination_id and movie_id."""
    try:
        data = DeleteMovieNominationRequest.model_validate(
            {"nomination_id": id, "movie_id": movie_id}
        )
    except ValidationError as e:
        return jsonify({"errors": e.errors()}), 400
    success = delete_movie_nomination(data.nomination_id, data.movie_id)
    if success is False:
        raise BadRequest(
            f"Error deleting MovieNomintion for Nomination: {data.nomination_id} Movie: {data.movie_id}"
        )
    return ("", 200)


@bp.route("/nominations/check", methods=["POST"])
def post_nomination_check():
    """Check a nomination."""
    try:
        data = CheckNominationRequest.model_validate(request.get_json(silent=True))
    except ValidationError as e:
        return jsonify({"errors": e.errors()}), 400

    success = check_nominations(data.imdb_event_id, data.year, data.award_id)
    if success is False:
        raise BadRequest(
            f"No Nominations found for Event: {data.imdb_event_id} Award: {data.award_id} Year: {data.year}",
        )

    return ("", 200)
