from datetime import datetime

from flask import Blueprint, jsonify, request

from api.services.demographics_service import get_movie_cast_demographics_by_nomination

bp = Blueprint("demographics", __name__, url_prefix="/demographics")


@bp.route("")
def get_demographics():
    """Return movie demographics for a given nomination year."""

    eventQuery = request.args.get("event")
    rangeQuery = request.args.get("range")
    yearQuery = request.args.get("year")
    if eventQuery is None or rangeQuery is None or yearQuery is None:
        return jsonify(
            {"error": "Missing required query params: event, range, year"}
        ), 400

    movies_data = []
    if rangeQuery == "cumulative":
        years = yearQuery.split("-")[1]
        current_year = datetime.now().year
        for i in range(int(years)):
            movie_data = get_movie_cast_demographics_by_nomination(
                eventQuery, int(current_year) - i
            )
            movies_data.extend(movie_data)
    else:
        movies_data = get_movie_cast_demographics_by_nomination(
            eventQuery, int(yearQuery)
        )
    return jsonify(movies_data)
