"""Script to seed database."""

import server
from model import db, connect_to_db, Movie, Genre, MediaGenre
import os
import json
from datetime import datetime

os.system("dropdb demographix")
os.system("createdb demographix")

connect_to_db(server.app)
db.create_all()


"""Seed genre table in database."""

print('Seeding genres...')
with open('data/genres.json') as file:
    genre_list = json.loads(file.read())

genres_in_db = []
for genre in genre_list["genres"]:
    new_genre = Genre(genre_id=genre["id"],
                      name=genre["name"])
    genres_in_db.append(new_genre)
    print(f'Adding {new_genre}...')
db.session.add_all(genres_in_db)
db.session.commit()

print(f"Added {len(genres_in_db)} genres to database!")


with open('data/movie_details.json') as file:
    movie_data = json.loads(file.read())

movies_in_db = []

for movie in movie_data:
    format = "%Y-%m-%d"
    formatted_date = datetime.strptime(movie['release_date'], format)
    new_movie = Movie(movie_id=movie["id"],
                      imdb_id=movie["imdb_id"],
                      title=movie["title"],
                      overview=movie["overview"],
                      runtime=movie["runtime"],
                      poster_path=movie["poster_path"],
                      release_date=formatted_date,
                      budget=movie["budget"],
                      revenue=movie["revenue"])
    movies_in_db.append(new_movie)
    for genre in movie["genres"]:
        id = genre["id"]
        genre_object = Genre.query.filter(Genre.genre_id == id).one()
        new_movie.genres.append(genre_object)
        print(f"Added {genre_object.name} to {new_movie.title}")

db.session.add_all(movies_in_db)
db.session.commit()

print(movies_in_db)
