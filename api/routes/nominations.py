from data.nominations import get_nom_movies, query_imdb_event_nominations
from flask import Blueprint, jsonify

bp = Blueprint("nominations", __name__, url_prefix="/nom")


@bp.route("/<year>")
def nom(year):
    """Return demographics of oscar nominated movies for a given year in json."""

    summary = year.split(" ")
    if len(summary) > 1:
        _, years = summary
        movies_data = []
        current_year = year
        for i in range(int(years)):
            movie_data = get_nom_movies("Academy Awards", int(current_year) - i)
            movies_data.extend(movie_data)
    else:
        movies_data = get_nom_movies("Academy Awards", year)
    return jsonify(movies_data)


@bp.route("/imdb/<event>/<year>")
def query_nominations(event: str, year: int):
    """Route to query nominations for a given event and year from IMDB."""
    results = query_imdb_event_nominations(event, year)
    return jsonify(results)
