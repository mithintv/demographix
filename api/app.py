"""Server for demographix app."""

from datetime import datetime
from flask import (Flask, render_template, request,
                   flash, jsonify, session, redirect, send_from_directory)
from flask_migrate import Migrate
from model import connect_to_db
import crud

app = Flask(__name__)
app.secret_key = 'demographix_dev'


migrate = Migrate(app, connect_to_db(app))


@app.route('/', methods=['POST'])
def query():
    """Return search results from database in json."""

    data = request.get_json()
    keywords = data['search']
    query_data = crud.query_movie(keywords)

    search_results = []
    for movie in query_data:
        movie_dict = {'id': movie.id,
                      'title': movie.title,
                      'release_date': movie.release_date,
                      'poster_path': movie.poster_path,
                      }
        search_results.append(movie_dict)

    return jsonify(search_results)


@app.route('/search', methods=['POST'])
def query_api():
    """Return search results from api in json. Currently set to run if 'search' button is pressed"""

    data = request.get_json()
    keywords = data['search']

    api_results = crud.query_api_movie(keywords)

    search_results = []
    print("Search results...")
    for movie in api_results:
        movie_dict = {'id': movie.id,
                      'title': movie.title,
                      'release_date': movie.release_date,
                      'poster_path': movie.poster_path,
                      }
        search_results.append(movie_dict)

        print(f"{movie.title} ({movie.release_date.year})")

    return jsonify(search_results)


@app.route('/api/nom/<year>')
def nom(year):
    """Return demographics of oscar nominated movies for a given year in json"""

    summary = year.split(' ')
    if len(summary) > 1:
        _, years = summary
        movies_data = []
        current_year = datetime.now().year
        for i in range(int(years)):
            movie_data = crud.get_nom_movies(int(current_year) - i)
            movies_data.extend(movie_data)
    else:
        movies_data = crud.get_nom_movies(year)
    return jsonify(movies_data)


@app.route('/api/movies/<movie_id>')
def movie(movie_id):
    """Return movie and cast details in json."""

    movie_data = crud.get_movie_cast(movie_id)
    return jsonify(movie_data)


@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def catch_all(path):
    return render_template('page.html')


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
