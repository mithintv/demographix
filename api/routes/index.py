import logging

import crud
from flask import Blueprint, jsonify, make_response, request

bp = Blueprint("index", __name__, url_prefix="/")

@bp.route("/", methods=["POST"])
def query():
    """Return search results from database in json."""

    data = request.get_json()
    keywords = data["search"]
    query_data = crud.query_movie(keywords)

    search_results = []
    for movie in query_data:
        movie_dict = {
            "id": movie.id,
            "title": movie.title,
            "release_date": movie.release_date,
            "poster_path": movie.poster_path,
        }
        search_results.append(movie_dict)

    return jsonify(search_results)


@bp.route('/', defaults={'path': ''}, methods=["GET", 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'])
@bp.route("/<path:path>", methods=["GET", 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'])
def catch_all(path):
    """Catch all route."""
    logging.error(path)
    return make_response("", 404)
