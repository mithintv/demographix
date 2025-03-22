import logging

from services.movie_service import movie_service
from flask import Blueprint, jsonify

bp = Blueprint("movies", __name__, url_prefix="/movies")


@bp.route("/<movie_id>")
def movie_and_cast(movie_id):
    """Return movie and cast details in json."""

    movie_data = movie_service.get_movie_and_cast(movie_id)
    return jsonify(movie_data)
