"""CRUD operations."""

import requests
import os
import time
from datetime import datetime
from sqlalchemy import func, and_, or_
from model import db, Movie, Genre, Credit, CastMember, Gender, Ethnicity, AltEthnicity, Race, Country, AltCountry, connect_to_db

from data.ethnicity import *

key = os.environ['API_KEY']
access_token = os.environ['ACCESS_TOKEN']


def get_regions():
    """Return all regions and subregions"""

    print(db.session.query(Country.subregion, Country.region).group_by(
        Country.subregion, Country.region).order_by(Country.subregion.asc()).all())
    return db.session.query(Country.subregion, Country.region).group_by(Country.subregion, Country.region).order_by(Country.subregion.asc()).all()


def get_movies():
    """Return all movies."""

    return Movie.query.all()


def add_movie_from_search(movie):
    format = "%Y-%m-%d"
    formatted_date = datetime.strptime(movie['release_date'], format)
    new_movie = Movie(id=movie["id"],
                      title=movie["title"],
                      overview=movie["overview"],
                      poster_path=movie["poster_path"],
                      release_date=formatted_date)
    print(f'Created new movie: {new_movie.title}')
    for id in movie["genre_ids"]:
        genre_object = Genre.query.filter(Genre.id == id).one()
        new_movie.genres.append(genre_object)
    return new_movie


def update_movie_with_movie_details(movie, movie_details):
    """Update movie from api call for movie details."""

    movie.imdb_id = movie_details["imdb_id"]
    movie.runtime = movie_details["runtime"]
    movie.budget = movie_details["budget"]
    movie.revenue = movie_details["revenue"]

    print(f'Updated existing movie: {movie.title}')


def add_cast_member(person):
    """Add cast member information from api call."""

    # Add basic cast member data
    format = "%Y-%m-%d"
    formatted_bday = None
    if person['birthday'] is not None:
        formatted_bday = datetime.strptime(person['birthday'], format)

    formatted_dday = None
    if person['deathday'] is not None:
        formatted_dday = datetime.strptime(person['deathday'], format)

    new_person = CastMember(id=person['id'],
                            imdb_id=person['imdb_id'],
                            name=person['name'],
                            birthday=formatted_bday,
                            deathday=formatted_dday,
                            biography=person['biography'])

    # Add gender data
    id = person["gender"]
    gender_object = Gender.query.filter(Gender.id == id).one()
    new_person.gender = gender_object

    # Add country_of_birth data
    if person.get("place_of_birth", None) is not None:
        country = person["place_of_birth"].split(',')
        country_object = Country.query.join(AltCountry).filter(
            (Country.id == country[-1].strip()) | (Country.name == country[-1].strip()) | (AltCountry.alt_name == country[-1].strip())).first()
        new_person.country_of_birth = country_object

    # Add ethnicity data
    print(f"Finding ethnicity information about {new_person.name}...")
    ethnicity_list = get_ethnicity(person)
    if ethnicity_list != None:
        add_ethnicities = set([])
        for ethnicity in ethnicity_list:
            ethnicity_object = Ethnicity.query.outerjoin(AltEthnicity).filter(
                (Ethnicity.name == ethnicity) | (AltEthnicity.alt_name == ethnicity)).first()

            if ethnicity_object is not None and ethnicity_object.id not in add_ethnicities:
                add_ethnicities.add(ethnicity_object.id)
                print(
                    f"Adding {ethnicity_object.name} to {new_person.name}")
                new_person.ethnicities.append(ethnicity_object)

    # Add race data
    print(f"Adding approximate race data...")
    add_race_ids = set()
    if len(new_person.ethnicities) == 0:
        print("Cannot approximate race data without ethnicity data...\n")

    else:
        for ethnicity in new_person.ethnicities:
            if ethnicity.region != None:
                approx_country = ethnicity
            else:
                approx_country = Country.query.filter(
                    Country.demonym == ethnicity.name).first()

            if approx_country != None:
                print(
                    f"{approx_country.name} {approx_country.region.name} {approx_country.subregion.name}")

                if approx_country.region.name == 'Europe':
                    white = Race.query.filter(Race.short == 'WHT').one()
                    add_race_ids.add(white.id)

                if approx_country.subregion.name in ['Central Asia', 'Western Asia']:
                    mena = Race.query.filter(Race.short == 'MENA').one()
                    add_race_ids.add(mena.id)

                if approx_country.region.name == 'Africa':
                    black = Race.query.filter(Race.short == 'BLK').one()
                    add_race_ids.add(black.id)

                if approx_country.subregion.name in ['Central America', 'South America'] or approx_country.name in ['Mexico', 'Puerto Rico', 'Cuba']:
                    hispanic = Race.query.filter(
                        Race.short == 'HSPN').one()
                    add_race_ids.add(hispanic.id)

                if approx_country.subregion.name in ['Eastern Asia', 'South-Eastern Asia', 'Southern Asia']:
                    asian = Race.query.filter(Race.short == 'ASN').one()
                    add_race_ids.add(asian.id)

                if approx_country.subregion.name in ['Polynesia', 'Micronesia', 'Melanesia']:
                    nhpi = Race.query.filter(Race.short == 'NHPI').one()
                    add_race_ids.add(nhpi.id)

            else:
                print(
                    f'Could not associate {ethnicity.name} with a country')
                if ethnicity.name in ['English', 'Cornish', 'Scottish', 'Welsh', 'Jewish']:
                    white = Race.query.filter(Race.short == 'WHT').one()
                    add_race_ids.add(white.id)
                if ethnicity.name == 'African American' or ethnicity.name == 'African':
                    black = Race.query.filter(Race.short == 'BLK').one()
                    add_race_ids.add(black.id)
                if ethnicity.name == 'Hawaiian':
                    nhpi = Race.query.filter(Race.short == 'NHPI').one()
                    add_race_ids.add(nhpi.id)

        for race in add_race_ids:
            new_race = Race.query.filter(Race.id == race).one()
            print(f"Adding {new_race.name} as a race...")
            new_person.races.append(new_race)

    print('Sleeping for 5 seconds...\n')
    time.sleep(5)

    return new_person


def add_credits(credit_list, curr_movie):
    """Add credits for a given credit list for a movie."""

    new_credits = []
    for cast in credit_list:
        cast_member = CastMember.query.filter(
            CastMember.id == cast["id"]).one()
        new_credit = Credit(id=cast["credit_id"],
                            movie_id=curr_movie,
                            character=cast["character"],
                            order=cast["order"],
                            cast_member_id=cast_member,
                            movie=curr_movie,
                            cast_member=cast_member)

        new_credits.append(new_credit)

    db.session.add_all(new_credits)
    db.session.commit()
    print(f"Added {len(new_credits)} credits to db!")


def query_movie(keywords):
    """Return search query results."""

    filters = [func.lower(Movie.title).like(
        f'%{keyword.lower()}%') for keyword in keywords]
    return Movie.query.filter(or_(*filters)).all()


def query_api_movie(keywords):
    """Return search query results from api."""

    filters = [func.lower(Movie.title).like(
        f'%{keyword.lower()}%') for keyword in keywords]
    query = Movie.query.filter(or_(*filters)).all()

    if len(query) < 10:
        print("Not enough results in db... making API call...")
        joined_keywords = " ".join(keywords)
        response = requests.get(
            f'https://api.themoviedb.org/3/search/movie?api_key={key}&query={joined_keywords}')
        result_list = response.json()
        movies = result_list['results']
        print(len(movies))

        new_movies = []
        for movie in movies:
            curr_movie = Movie.query.filter(Movie.id == movie['id']).first()
            if curr_movie is None:
                curr_movie = add_movie_from_search(movie)
                new_movies.append(curr_movie)
                print(f"Adding new move to db: {curr_movie.title}...")

            query.append(curr_movie)

        db.session.add_all(new_movies)
        db.session.commit()
        print(f"Added {len(new_movies)} movies to db!")

    return query


def query_api_movie_details(movie_id):
    url = f"https://api.themoviedb.org/3/movie/{movie_id}?language=en-US"
    headers = {
        "accept": "application/json",
        "Authorization": f"Bearer {access_token}"
    }
    response = requests.get(url, headers=headers)
    movie_details = response.json()
    print(f"Movie Details...\n{movie_details}")
    return movie_details


def query_api_credits(movie_id):
    """Return cast credit list of a given movie."""

    url = f"https://api.themoviedb.org/3/movie/{movie_id}/credits?api_key={key}&language=en-US"
    response = requests.get(url)
    movie_credits = response.json()
    print(f"Credits...\n{movie_credits['cast']}")

    return movie_credits['cast']


def query_api_people(credit_list):
    """Create cast members for given list of credits."""

    cast_member_list = []
    for person in credit_list:
        person_query = CastMember.query.filter(
            CastMember.id == person['id']).first()

        if person_query == None:
            print(
                f"{person['name']} doesn't exist in database...\nMaking api call...")
            url = f"https://api.themoviedb.org/3/person/{person['id']}?api_key={key}"
            response = requests.get(url)
            person = response.json()

            cast_member = add_cast_member(person)
            cast_member_list.append(cast_member)

    db.session.add_all(cast_member_list)
    db.session.commit()
    print(f"Added {len(cast_member_list)} cast to db!")


def get_movie_cast(movie_id):
    """Return specific movie with credits and cast member details."""

    movie = Movie.query.filter(Movie.id == movie_id).one()
    if movie.imdb_id == None:
        print(f"Movie details are missing...\nMaking api call...")

        # Update movie
        movie_details = query_api_movie_details(movie_id)
        update_movie_with_movie_details(movie, movie_details)

        # Get cast list and add cast members
        cast_credit_list = query_api_credits(movie_id)
        query_api_people(cast_credit_list)

        # Add credits after adding cast members
        add_credits(cast_credit_list, movie)

    cast_list = db.session.query(
        CastMember,
        Gender,
        Country,
        Credit
    ).join(Gender, Gender.id == CastMember.gender_id
           ).join(Country, Country.id == CastMember.country_of_birth_id
                  ).join(Credit, Credit.cast_member_id == CastMember.id
                         ).join(Movie, Movie.id == Credit.movie_id
                                ).filter(Movie.id == movie_id
                                         ).order_by(Credit.order).all()

    cast_details = []
    for cast in cast_list:

        cast_member = CastMember.query.filter(
            CastMember.id == cast.CastMember.id).one()
        ethnicities = [ethnicity.name for ethnicity in cast_member.ethnicities]
        races = [race.name for race in cast_member.races]

        new_cast = {'name': cast.CastMember.name,
                    'birthday': cast.CastMember.birthday,
                    'gender': cast.Gender.name,
                    'ethnicity': ethnicities,
                    'race': races,
                    'country_of_birth': cast.Country.name,
                    'character': cast.Credit.character,
                    'order': cast.Credit.order}
        cast_details.append(new_cast)

    data = {
        'title': movie.title,
        'overview': movie.overview,
        'runtime': movie.runtime,
        'poster_path': movie.poster_path,
        'release_date': movie.release_date,
        'budget': movie.budget,
        'revenue': movie.revenue,
        'cast': cast_details
    }
    print(data)
    return data


if __name__ == '__main__':
    from server import app
    connect_to_db(app)
