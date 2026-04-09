"""Nomination routes."""

from flask import Blueprint, jsonify, request

from api.data.events.event_repository import query_events
from api.data.nominations.nomination_repository import (
    query_nomination_awards,
    query_nomination_movies,
    query_nomination_years,
)

bp = Blueprint("nominations", __name__, url_prefix="/nominations")


@bp.route("", methods=["GET"])
def get_nominations():
    """Get nomination data."""
    projection = request.args.get("projection")

    if projection == "events":
        events = query_events()
        return jsonify({"results": [e.to_dict() for e in events], "total": len(events)})
    elif projection == "years":
        nomination_years = query_nomination_years()
        return jsonify(
            {
                "results": [{"id": ny, "name": ny} for ny in nomination_years],
                "total": len(nomination_years),
            }
        )
    elif projection == "awards":
        nomination_awards = query_nomination_awards()
        return jsonify(
            {
                "results": [na.to_dict() for na in nomination_awards],
                "total": len(nomination_awards),
            }
        )
    elif projection == "movies":
        nomination_movies = query_nomination_movies()
        return jsonify(
            {
                "results": [nm.to_dict() for nm in nomination_movies],
                "total": len(nomination_movies),
            }
        )
    else:
        raise Exception()
