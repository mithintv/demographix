"""Admin routes for data validity checking."""

import logging

from flask import Blueprint, abort, jsonify, request
from pydantic import ValidationError

from api.data.nominations.nomination_dto import (
    CheckNominationRequest,
    CreateNominationRequest,
)
from api.data.nominations.nomination_repository import (
    create_nomination,
    search_nominations,
)
from api.services.nomination_service import check_nominations

bp = Blueprint("admin", __name__, url_prefix="/admin")


@bp.route("/nominations")
def get_nominations():
    """Return nominations grouped by award name, with their associated movies."""
    search = request.args.get("search", None)
    if search is not None:
        search = search.strip()
    results = search_nominations(search)
    return jsonify({"nominations": results, "total": len(results)})


@bp.route("/nominations", methods=["POST"])
def post_nominations():
    """Create a new nomination."""
    try:
        data = CreateNominationRequest.model_validate(request.get_json(silent=True))
    except ValidationError as e:
        abort(400, e.errors())
    nom = create_nomination(data.name, data.year)
    return jsonify(nom), 200


@bp.route("/nominations/check", methods=["POST"])
def post_nomination_check():
    """Check a nomination."""
    try:
        data = CheckNominationRequest.model_validate(request.get_json(silent=True))
    except ValidationError as e:
        abort(400, e.errors())
    check_nominations(data.name, data.year)
    return ("", 200)
