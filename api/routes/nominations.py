from datetime import datetime

from api.data.nominations import query_imdb_and_add_nomination, query_imdb_event_nominations
from flask import Blueprint, jsonify, request

from api.services.movie_nomination_service import movie_nomination_service

bp = Blueprint("nominations", __name__, url_prefix="/nom")


@bp.route("/query")
def nom():
    """Return demographics of oscar nominated movies for a given year in json."""

    awardQuery = request.args.get("award")
    rangeQuery = request.args.get("range")
    yearQuery = request.args.get("year")

    movies_data = []
    if rangeQuery == "cumulative":
        years = yearQuery.split("-")[1]
        current_year = datetime.now().year
        for i in range(int(years)):
            movie_data = movie_nomination_service.get_nom_movies(
                awardQuery, int(current_year) - i
            )
            movies_data.extend(movie_data)
    else:
        movies_data = movie_nomination_service.get_nom_movies(awardQuery, yearQuery)
    return jsonify(movies_data)


@bp.route("/imdb/<event>/<year>", methods=["GET"])
def query_nominations(event: str, year: int):
    """Route to query nominations for a given event and year from IMDB."""
    results = query_imdb_event_nominations(event, year)
    return jsonify(results)


@bp.route("/imdb/<event>/<year>", methods=["POST"])
def query_and_add_nominations(event: str, year: int):
    """Query nominations for a given event and year from IMDB and create nominations from them."""
    results = query_imdb_and_add_nomination(event, int(year))
    return jsonify(results)
