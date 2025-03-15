from datetime import datetime

from data.nominations import get_nom_movies, query_imdb_event_nominations
from flask import Blueprint, jsonify, request

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
            movie_data = get_nom_movies(awardQuery, int(current_year) - i)
            movies_data.extend(movie_data)
    else:
        movies_data = get_nom_movies(awardQuery, yearQuery)
    return jsonify(movies_data)


@bp.route("/imdb/<event>/<year>")
def query_nominations(event: str, year: int):
    """Route to query nominations for a given event and year from IMDB."""
    results = query_imdb_event_nominations(event, year)
    return jsonify(results)
