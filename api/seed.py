"""Script to seed database."""

import server
from model import db, connect_to_db, Country, AltCountry, Movie, Genre, Gender, Ethnicity, CastMember, Credit
import os
import json
from datetime import datetime

os.system("dropdb demographix")
os.system("createdb demographix")

connect_to_db(server.app)
db.create_all()

"""Seed countries table with country information."""

countries_list = []
with open('data/countries.json', 'r') as file:
    data = json.load(file)
    for country in data:
        if country.get("demonyms", None) is None:
            demonym = "Unknown"
        else:
            demonym = country["demonyms"]["eng"]["f"]

        new_country = Country(country_id=country['cca3'],
                              name=country["name"]["common"],
                              demonym=demonym,
                              region=country["region"])

        for alt_spelling in country["altSpellings"]:
            new_alt_spelling = AltCountry(country_id=new_country,
                                          alt_name=alt_spelling)
            new_country.alt_names.append(new_alt_spelling)

        countries_list.append(new_country)

db.session.add_all(countries_list)
db.session.commit()
print(f"Added {len(countries_list)} countries to db!")


"""Seed ethnicities table with ethnicity information."""

countries_list = []
with open('data/ethnicities.json', 'r') as file:
    data = json.load(file)

    ethnicities_list = []
    for ethnicity in data:
        if ethnicity not in ['Alabama',
                             'Alaska',
                             'Arizona',
                             'Arkansas',
                             'California',
                             'Colorado',
                             'Connecticut',
                             'Delaware',
                             'District of Columbia'
                             'Florida',
                             'Georgia',
                             'Hawaii',
                             'Idaho',
                             'Illinois',
                             'Indiana',
                             'Iowa',
                             'Kansas',
                             'Kentucky',
                             'Louisiana',
                             'Maine',
                             'Maryland',
                             'Massachusetts',
                             'Michigan',
                             'Minnesota',
                             'Mississippi',
                             'Missouri',
                             'Montana',
                             'Nebraska',
                             'Nevada',
                             'New Hampshire',
                             'New Jersey',
                             'New Mexico',
                             'New York',
                             'North Carolina',
                             'North Dakota',
                             'Ohio',
                             'Oklahoma',
                             'Oregon',
                             'Pennsylvania',
                             'Rhode Island',
                             'South Carolina',
                             'South Dakota',
                             'Tennessee',
                             'Texas',
                             'Utah',
                             'Vermont',
                             'Virginia',
                             'Washington',
                             'West Virginia',
                             'Wisconsin',
                             'Wyoming']:
            new_ethnicity = Ethnicity(name=ethnicity)

            ethnicities_list.append(new_ethnicity)

db.session.add_all(ethnicities_list)
db.session.commit()
print(f"Added {len(ethnicities_list)} ethnicities to db!")


"""Seed genres table in database."""

with open('data/genres.json') as file:
    genre_list = json.loads(file.read())

genres_in_db = []
for genre in genre_list["genres"]:
    new_genre = Genre(genre_id=genre["id"],
                      name=genre["name"])
    genres_in_db.append(new_genre)

db.session.add_all(genres_in_db)
db.session.commit()
print(f"Added {len(genres_in_db)} genres to db!")


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

db.session.add_all(movies_in_db)
db.session.commit()
print(f"Added {len(movies_in_db)} movies to db!")


"""Seed genders table in database."""

gender_list = ['Unknown', 'Female', 'Male', 'Non-Binary']
genders_in_db = []
for i in range(len(gender_list)):
    new_gender = Gender(gender_id=i, name=gender_list[i])
    genders_in_db.append(new_gender)

db.session.add_all(genders_in_db)
db.session.commit()
print(f'Added {len(genders_in_db)} genders to db!')


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
                            biography=person['biography']
                            )
    persons_in_db.append(new_person)

    # Add gender data
    id = person["gender"]
    gender_object = Gender.query.filter(Gender.gender_id == id).one()
    new_person.gender = gender_object

    # Add country_of_birth data
    if person.get("place_of_birth", None) is not None:
        country = person["place_of_birth"].split(',')
        country_object = Country.query.join(AltCountry).filter(
            (Country.country_id == country[-1].strip()) | (Country.name == country[-1].strip()) | (AltCountry.alt_name == country[-1].strip())).first()
        new_person.country_of_birth = country_object


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

        credits_in_db.append(new_credit)

db.session.add_all(credits_in_db)
db.session.commit()
print(f"Added {len(credits_in_db)} credits to db!")
