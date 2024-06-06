"""Server for demographix app."""

import datetime
import logging

import crud
from data.gpt import txtcomp
from flask import Flask, jsonify, render_template, request
from flask_migrate import Migrate
from model import connect_to_db

app = Flask(__name__)
app.secret_key = "demographix_dev"

# Enable logging
logging.basicConfig(
    level=logging.INFO,
    format="[%(asctime)s.%(msecs)03d %(name)s:%(levelname)s] - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
migrate = Migrate(app, connect_to_db(app))


@app.route("/", methods=["POST"])
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
    """Return search results from api in json. Currently set to run if 'search' button is pressed"""

    data = request.get_json()
    keywords = data["search"]

    api_results = crud.query_api_movie(keywords)

    search_results = []
    logging.info("Search results...")
    for movie in api_results:
        movie_dict = {
            "id": movie.id,
            "title": movie.title,
            "release_date": movie.release_date,
            "poster_path": movie.poster_path,
        }
        search_results.append(movie_dict)

        logging.info(f"<Movie id={movie.id} title={movie.title}>")

    return jsonify(search_results)


@app.route("/nom/<year>")
def nom(year):
    """Return demographics of oscar nominated movies for a given year in json"""

    summary = year.split(" ")
    if len(summary) > 1:
        _, years = summary
        movies_data = []
        current_year = year
        for i in range(int(years)):
            movie_data = crud.get_nom_movies(int(current_year) - i)
            movies_data.extend(movie_data)
    else:
        movies_data = crud.get_nom_movies(year)
    return jsonify(movies_data)


@app.route("/movies/<movie_id>")
def movie(movie_id):
    """Return movie and cast details in json."""

    logging.info(movie_id)
    movie_data = crud.get_movie_cast(movie_id)
    return jsonify(movie_data)


@app.route("/test/openai", methods=["POST"])
def openai():
    data = request.get_json()
    article = data["article"]
    result = txtcomp(article, verify=False)
    return jsonify(result)


@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def catch_all(path):
    """Catch all route."""
    logging.info(path)
    return


if __name__ == "__main__":
    app.run(host="0.0.0.0")
