"""Script to seed database."""

import server
import model
import os
import json
from datetime import datetime

os.system("dropdb demographix")
os.system("createdb demographix")

model.connect_to_db(server.app)
model.db.create_all()

with open('data/movie_details.json') as file:
    movie_data = json.loads(file.read())

movies_in_db = []
for movie in movie_data:
    format = "%Y-%m-%d"
    formatted_date = datetime.strptime(movie['release_date'], format)
    new_movie = model.Movie(movie_id=movie["id"],
                            imdb_id=movie["imdb_id"],
                            title=movie["title"],
                            overview=movie["overview"],
                            runtime=movie["runtime"],
                            poster_path=movie["poster_path"],
                            release_date=formatted_date,
                            budget=movie["budget"],
                            revenue=movie["revenue"])
    movies_in_db.append(new_movie)

print(movies_in_db)
model.db.session.add_all(movies_in_db)
model.db.session.commit()
