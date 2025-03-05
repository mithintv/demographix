import logging

from data.cast import get_movie_cast
from flask import Blueprint, jsonify

bp = Blueprint("movies", __name__, url_prefix="/movies")


@bp.route("/<movie_id>")
def movie_and_cast(movie_id):
    """Return movie and cast details in json."""

    logging.info(movie_id)
    movie_data = get_movie_cast(movie_id)
    return jsonify(movie_data)
