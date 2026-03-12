from datetime import datetime

from flask import Blueprint, jsonify, request

from api.services.demographics_service import get_movie_cast_demographics_by_nomination

bp = Blueprint("demographics", __name__, url_prefix="/demographics")


@bp.route("")
def get_demographics():
    """Return movie demographics for a given nomination year."""

    awardQuery = request.args.get("award") or "academy awards"
    rangeQuery = request.args.get("range") or "yearly"
    yearQuery = request.args.get("year") or str(datetime.now().year)

    movies_data = []
    if rangeQuery == "cumulative":
        years = yearQuery.split("-")[1]
        current_year = datetime.now().year
        for i in range(int(years)):
            movie_data = get_movie_cast_demographics_by_nomination(
                awardQuery, int(current_year) - i
            )
            movies_data.extend(movie_data)
    else:
        movies_data = get_movie_cast_demographics_by_nomination(
            awardQuery, int(yearQuery)
        )
    return jsonify(movies_data)
