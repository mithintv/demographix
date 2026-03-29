import os

from flask import Blueprint, make_response, redirect

from api.services.logging_service import get_logger

logger = get_logger(__name__)

bp: Blueprint = Blueprint("index", __name__, url_prefix="/")


@bp.route("/", methods=["GET"])
def get_index():
    client_hostname = "http://localhost:5173"
    if os.environ["FLASK_ENV"] == "production":
        client_hostname = os.environ["CLIENT_HOSTNAME"]
    return redirect(client_hostname)


@bp.route("", methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"])
@bp.route("/<path:path>", methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"])
def catch_all(path):
    """Catch all route."""
    logger.error(path)
    return make_response("", 404)
