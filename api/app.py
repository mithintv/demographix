"""Server for demographix app."""

import logging
import os
import sys

import structlog
from dotenv import load_dotenv
from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_migrate import Migrate
from flask_problem_details import ProblemDetails
from pydantic import AnyUrl
from sqlalchemy import text
from werkzeug.exceptions import HTTPException

import api.data  # noqa: F401 - ensures all models are registered
from api.data.base import db
from api.data.gpt import txtcomp
from api.routes import admin, demographics, index, movies, nominations
from api.services.logging_service import configure_logging, get_logger

load_dotenv()
configure_logging()

app = Flask(__name__, instance_relative_config=True)

origins = ["http://localhost:5173", "http://localhost:4173"]
if os.environ["FLASK_ENV"] == "production":
    origins = [os.environ["CLIENT_HOSTNAME"]]
CORS(app, origins=origins)
app.secret_key = os.environ["APP_SECRET_KEY"]

# Register prefixed route handlers
app.register_blueprint(index.bp)
app.register_blueprint(movies.bp)
app.register_blueprint(demographics.bp)
app.register_blueprint(nominations.bp)
if os.environ.get("FLASK_ENV") != "production":
    app.register_blueprint(admin.bp)

DB_URI = os.environ.get("DB_URI", "postgresql:///demographix")
app.config["SQLALCHEMY_DATABASE_URI"] = DB_URI
app.config["SQLALCHEMY_RECORD_QUERIES"] = True
app.config["SQLALCHEMY_ECHO"] = False
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db.init_app(app)
Migrate(app, db)


RFC9110_STATUS_URIS: dict[int, AnyUrl] = {
    400: AnyUrl("https://tools.ietf.org/html/rfc9110#section-15.5.1"),
    401: AnyUrl("https://tools.ietf.org/html/rfc9110#section-15.5.2"),
    403: AnyUrl("https://tools.ietf.org/html/rfc9110#section-15.5.4"),
    404: AnyUrl("https://tools.ietf.org/html/rfc9110#section-15.5.5"),
    405: AnyUrl("https://tools.ietf.org/html/rfc9110#section-15.5.6"),
    409: AnyUrl("https://tools.ietf.org/html/rfc9110#section-15.5.10"),
    422: AnyUrl("https://tools.ietf.org/html/rfc9110#section-15.5.21"),
    429: AnyUrl("https://tools.ietf.org/html/rfc9110#section-15.5.29"),
    500: AnyUrl("https://tools.ietf.org/html/rfc9110#section-15.6.1"),
    501: AnyUrl("https://tools.ietf.org/html/rfc9110#section-15.6.2"),
    503: AnyUrl("https://tools.ietf.org/html/rfc9110#section-15.6.4"),
}


with app.app_context():
    try:
        db.session.execute(text("SELECT 1"))
    except Exception as e:
        get_logger().critical("db_unreachable", error=str(e))
        logging.getLogger(__name__).critical("db_unreachable: %s", e)
        sys.exit(1)


@app.before_request
def bind_request_context():
    structlog.contextvars.clear_contextvars()
    structlog.contextvars.bind_contextvars(
        request_method=request.method,
        request_path=request.path,
        request_query_params=dict(request.args),
    )


@app.route("/test/openai", methods=["POST"])
def openai():
    """Retreive Open AI API result with given passage as json body."""
    data = request.get_json()
    article = data["article"]
    result = txtcomp(article, verify=False)
    return jsonify(result)


@app.errorhandler(HTTPException)
def handle_http_exception(e: HTTPException):
    code = e.code or 500
    pd = ProblemDetails(
        type=RFC9110_STATUS_URIS.get(code),
        title=e.name,
        status=code,
        detail=e.description,
        instance=AnyUrl(request.url),
        traceback=None,
    )
    return pd.to_http_response()


@app.errorhandler(Exception)
def handle_exception(e: Exception):
    get_logger().exception("unhandled_exception", exc_info=e)
    pd = ProblemDetails(
        type=RFC9110_STATUS_URIS[500],
        title="Internal Server Error",
        status=500,
        detail="The server encountered an unexpected condition that prevented it from fulfilling the request.",
        instance=AnyUrl(request.url),
        traceback=None,
    )
    return pd.to_http_response()


if __name__ == "__main__":
    app.run(host="0.0.0.0")
