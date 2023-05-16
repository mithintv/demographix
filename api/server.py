"""Server for demographix app."""

from datetime import datetime
from flask import (Flask, render_template, request,
                   flash, jsonify, session, redirect)
from model import connect_to_db
import crud

app = Flask(__name__)
app.secret_key = 'demographix_dev'


@app.route('/')
def homepage():
    """View homepage."""

    return render_template('page.html')


@app.route('/', methods=['POST'])
def query():
    """Return search results from database."""

    data = request.get_json()
    keywords = data['search'].split()
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
    """Return search results from api."""

    data = request.get_json()
    keywords = data['search'].split()

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


@app.route('/top')
def top():
    """Return oscar nominees."""

    all_movies = crud.get_movies()

    display_movies = []
    for movie in all_movies:
        movie_dict = {'id': movie.id,
                      'title': movie.title,
                      'release_date': movie.release_date,
                      'poster_path': movie.poster_path,
                      }
        display_movies.append(movie_dict)
    return jsonify(display_movies)


@app.route('/movies/<movie_id>')
def movie(movie_id):
    """Return movie and cast details."""

    movie_data = crud.get_movie_cast(movie_id)
    return jsonify(movie_data)


@app.route('/regions')
def region():
    """Return region and subregion details."""

    region_data = crud.get_regions()
    regions = []
    for region in region_data:
        regions.append({
            'subregion': region[0],
            'region': region[1]
        })
    return jsonify(regions)


if __name__ == "__main__":
    connect_to_db(app)
    app.run(host="0.0.0.0", debug=True)
