"""Script to seed database."""

import server
from model import db, connect_to_db, Movie, Genre, Gender, CastMember, Credit
import os
import json
from datetime import datetime

os.system("dropdb demographix")
os.system("createdb demographix")

connect_to_db(server.app)
db.create_all()


"""Seed genres table in database."""

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


"""Seed movies table in database."""

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
        print(f"Added '{genre_object.name}' genre to '{new_movie.title}'")

db.session.add_all(movies_in_db)
db.session.commit()


"""Seed genders table in database."""

gender_list = ['Unknown', 'Female', 'Male', 'Non-Binary']
genders_in_db = []
for i in range(len(gender_list)):
    new_gender = Gender(gender_id=i, name=gender_list[i])
    genders_in_db.append(new_gender)
    print(f'Adding {new_gender}...')

db.session.add_all(genders_in_db)
db.session.commit()
print(f'Added {len(genders_in_db)} genders to database!')


"""Seed cast_members table in database."""

with open('data/persons.json') as file:
    person_data = json.loads(file.read())

persons_in_db = []
for person in person_data:

    format = "%Y-%m-%d"
    formatted_bday = None
    if person['birthday'] is not None:
        formatted_bday = datetime.strptime(person['birthday'], format)

    formatted_dday = None
    if person['deathday'] is not None:
        formatted_dday = datetime.strptime(person['deathday'], format)

    new_person = CastMember(cast_member_id=person['id'],
                            imdb_id=person['imdb_id'],
                            name=person['name'],
                            birthday=formatted_bday,
                            deathday=formatted_dday,
                            biography=person['biography'])
    persons_in_db.append(new_person)

    id = person["gender"]
    gender_object = Gender.query.filter(Gender.gender_id == id).one()
    new_person.genders.append(gender_object)
    print(f"Added '{gender_object.name}' gender to '{new_person.name}'")

db.session.add_all(persons_in_db)
db.session.commit()
print(f"Added {len(persons_in_db)} cast members to db!")


"""Seed credits table in database."""

with open('data/credits.json') as file:
    credits_data = json.loads(file.read())

credits_in_db = []
for movie in credits_data:
    curr_movie = Movie.query.filter(Movie.movie_id == movie['id']).one()
    for cast in movie['cast'][:15]:
        cast_member = CastMember.query.filter(
            CastMember.cast_member_id == cast["id"]).one()
        new_credit = Credit(credit_id=cast["credit_id"],
                            movie_id=curr_movie,
                            character=cast["character"],
                            order=cast["order"],
                            cast_member_id=cast_member,
                            movie=curr_movie,
                            cast_member=cast_member)

        print(f"Added '{new_credit.character}' to '{curr_movie.title}'")

db.session.add_all(credits_in_db)
db.session.commit()
