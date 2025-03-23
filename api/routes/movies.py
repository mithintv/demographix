from flask import Blueprint, jsonify
from services.movie_service import movie_service

bp = Blueprint("movies", __name__, url_prefix="/movies")


@bp.route("/<movie_id>")
def movie_and_cast(movie_id):
    """Return movie and cast details in json."""

    movie_data = movie_service.get_movie_and_cast_by_id(movie_id)
    return jsonify(movie_data)
