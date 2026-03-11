"""Server for demographix app."""

import logging
import os

from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_migrate import Migrate
from werkzeug.exceptions import HTTPException

from api.data.gpt import txtcomp
from api.data.model import db
from api.routes import admin, index, movies, nominations

app = Flask(__name__, instance_relative_config=True)

origins = ["http://localhost:5173", "http://localhost:4173"]
if os.environ["FLASK_ENV"] == "production":
    origins = [os.environ["CLIENT_HOSTNAME"]]
CORS(app, origins=origins)
app.secret_key = "demographix_dev"

# Register prefixed route handlers
app.register_blueprint(index.bp)
app.register_blueprint(movies.bp)
app.register_blueprint(nominations.bp)
if os.environ.get("FLASK_ENV") != "production":
    app.register_blueprint(admin.bp)

DB_URI = "postgresql:///demographix"
if os.environ["FLASK_ENV"] == "production":
    DB_URI = os.environ["DB_URI"]
app.config["SQLALCHEMY_DATABASE_URI"] = DB_URI
app.config["SQLALCHEMY_RECORD_QUERIES"] = True
app.config["SQLALCHEMY_ECHO"] = False
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db.init_app(app)
Migrate(app, db)

# Enable logging
logging.basicConfig(
    level=logging.INFO,
    format="[%(asctime)s.%(msecs)03d %(name)s:%(levelname)s] - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)


@app.route("/test/openai", methods=["POST"])
def openai():
    """Retreive Open AI API result with given passage as json body."""
    data = request.get_json()
    article = data["article"]
    result = txtcomp(article, verify=False)
    return jsonify(result)


@app.errorhandler(HTTPException)
def handle_http_exception(e):
    """Return JSON for all HTTP errors (e.g. 400, 404, 422)."""
    logging.getLogger(__name__).error("%s %s: %s", e.code, e.name, e.description)
    return jsonify({"error": e.name}), e.code


if __name__ == "__main__":
    app.run(host="0.0.0.0")
