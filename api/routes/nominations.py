"""Nomination routes."""

from flask import Blueprint, jsonify, request

from api.data.events.event_repository import query_events
from api.data.nominations.nomination_repository import query_nomination_years

bp = Blueprint("nominations", __name__, url_prefix="/nominations")


@bp.route("", methods=["GET"])
def get_nominations():
    """Get nomination data."""
    projection = request.args.get("projection")

    if projection == "events":
        events = query_events()
        return jsonify([e.to_dict() for e in events])
    elif projection == "years":
        nomination_years = query_nomination_years()
        return jsonify([{"id": ny, "name": ny} for ny in nomination_years])
    else:
        raise Exception()
