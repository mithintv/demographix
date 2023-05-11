"""Server for demographix app."""

from flask import (Flask, render_template, request,
                   flash, jsonify, session, redirect)
from model import connect_to_db, db
import crud

app = Flask(__name__)
app.secret_key = "demographix_dev"


@app.route('/')
def homepage():
    """View homepage."""

    return render_template('page.html')


@app.route('/top')
def top():
    """Return oscar nominees."""

    all_movies = crud.get_movies()

    display_movies = []
    for movie in all_movies:
        movie_dict = {'movie_id': movie.movie_id,
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


if __name__ == "__main__":
    connect_to_db(app)
    app.run(host="0.0.0.0", debug=True)
