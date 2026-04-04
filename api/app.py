"""Server for demographix app."""

import os

import structlog
from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_migrate import Migrate

import api.data  # noqa: F401 - ensures all models are registered
from api.data.base import db
from api.data.gpt import txtcomp
from api.routes import admin, demographics, index, movies
from api.services.logging_service import configure_logging, get_logger

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
if os.environ.get("FLASK_ENV") != "production":
    app.register_blueprint(admin.bp)

DB_URI = os.environ.get("DB_URI", "postgresql:///demographix")
app.config["SQLALCHEMY_DATABASE_URI"] = DB_URI
app.config["SQLALCHEMY_RECORD_QUERIES"] = True
app.config["SQLALCHEMY_ECHO"] = False
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db.init_app(app)
Migrate(app, db)


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


@app.errorhandler(Exception)
def handle_exception(e: Exception):
    """Return JSON for all unhandled exceptions."""
    get_logger().exception("unhandled_exception", exc_info=e)
    return jsonify({"error": "Internal server error"}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0")
