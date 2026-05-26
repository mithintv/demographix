import math

from flask import Blueprint, jsonify, request

from api.data.movies.movie_dto import MovieDto
from api.data.movies.movie_repository import find_movie_and_details_by_id, query_movies

bp = Blueprint("movies", __name__, url_prefix="/movies")


@bp.route("", methods=["GET"])
def get_movies():
    """Return movie query results from database."""

    query = request.args.get("query", None)
    page = request.args.get("page", None, type=int)

    movies, total, per_page = query_movies(query, page=page)
    results = [MovieDto.from_model(m) for m in movies]
    return jsonify(
        {
            "results": results,
            "meta": {
                "page": page,
                "per_page": len(results),
                "total_items": total,
                "total_pages": math.ceil(total / per_page),
            },
        }
    )


@bp.route("/<movie_id>")
def get_movie_by_movie_id(movie_id):
    """Return movie and cast details."""

    movie_details = find_movie_and_details_by_id(movie_id)
    return jsonify(movie_details)
