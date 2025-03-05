"""Server for demographix app."""

import logging
import os

from data.gpt import txtcomp
from flask import Flask, jsonify, request
from flask_migrate import Migrate
from model import db
from routes import index, movies, nominations

app = Flask(__name__, instance_relative_config=True)
app.secret_key = "demographix_dev"

# Register prefixed route handlers
app.register_blueprint(index.bp)
app.register_blueprint(movies.bp)
app.register_blueprint(nominations.bp)

# Configure db w/ flask session
DB_URI = "postgresql:///demographix"
if os.environ["FLASK_ENV"] == "production":
    DB_URI = os.environ["DB_URI"]
app.config["SQLALCHEMY_DATABASE_URI"] = DB_URI
app.config["SQLALCHEMY_RECORD_QUERIES"] = True
app.config["SQLALCHEMY_ECHO"] = False
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db.init_app(app)
migrate = Migrate(app, db)

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

if __name__ == "__main__":
    app.run(host="0.0.0.0")
