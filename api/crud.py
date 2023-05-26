"""CRUD operations."""

import requests
import os
import time
from datetime import datetime
from sqlalchemy import func, and_, or_, desc
from model import *

from data.ethnicity import *
from data.palm import *

key = os.environ['TMDB_API_KEY']
access_token = os.environ['TMDB_ACCESS_TOKEN']


def add_source_data(new_person, ethnicity_object, source):
    formatted_source = "/".join(source.split("/")[0:3])

    original_source = Source.query.filter(
        Source.domain.like(f'%{formatted_source}%')).first()

    if original_source == None:
        original_source = Source(name=f"{formatted_source.split('.')[-2].capitalize()}", domain=f"{formatted_source}")
        db.session.add(original_source)
        print(f"Adding new source: {original_source.name} to db!")

    new_source_link = SourceLink.query.filter(SourceLink.link == source).first()
    if new_source_link == None:
        new_source_link = SourceLink(link=source, source_id=original_source.id)
        db.session.add(new_source_link)
        print(f"Adding new source link: {new_source_link.link} to db!")

    cast_ethnicity = CastEthnicity.query.filter(and_(CastEthnicity.cast_member_id == new_person.id, CastEthnicity.ethnicity_id == ethnicity_object.id)).first()
    if cast_ethnicity == None:
        cast_ethnicity = CastEthnicity(
            ethnicity_id=ethnicity_object.id, cast_member_id=new_person.id, ethnicity=ethnicity_object, )
        db.session.add(cast_ethnicity)

    if new_source_link not in cast_ethnicity.sources:
        cast_ethnicity.sources.append(new_source_link)
        print(f"Added new ref link: {new_source_link.link} for {ethnicity_object.name} ethnicity for {new_person.name}")

    return cast_ethnicity


def add_ethnicity_data(new_person):
    print(f"Finding ethnicity information about {new_person.name}...")
    results = get_ethnicity(new_person)
    if results.get('list', None) != None:
        ethnicity_list = results['list']
        source = results['source']

        # Check for duplicates
        existing_ethnicities = set([])
        for cast_ethnicity in new_person.ethnicities:
            existing_ethnicities.add(cast_ethnicity.ethnicity.id)
            # Update existing ethnicity sources
            if len(cast_ethnicity.sources) == 0:
                add_source_data(new_person, cast_ethnicity.ethnicity, source)

        # Add new ethnicities
        for ethnicity in ethnicity_list:
            ethnicity_object = Ethnicity.query.outerjoin(AltEthnicity).filter(
                (Ethnicity.name == ethnicity) | (AltEthnicity.alt_name == ethnicity)).first()

            if ethnicity_object is not None:
                # Query/Add source
                cast_ethnicity = add_source_data(new_person, ethnicity_object, source)

                if ethnicity_object.id in existing_ethnicities:
                    print(f"Skipping {ethnicity_object.name}... already stored...")
                    continue
                else:
                    new_person.ethnicities.append(cast_ethnicity)
                    print(
                        f"Adding {cast_ethnicity.ethnicity.name} to {new_person.name}")
    else:
        print("No ethnicity information found...")


def add_race_data(new_person):
    print(f"Adding approximate race data...")
    if len(new_person.ethnicities) == 0:
        print("Cannot approximate race data without ethnicity data...\n")
        return

    else:
        existing_races = set()
        for races in new_person.races:
            existing_races.add(races.id)

        add_race_ids = set()
        for cast_ethnicity in new_person.ethnicities:
            # If region is specified in ethnicity, set approx_country to that ethnicity which has region and subregion attributes. Otherwise, query a country object which also has region and subregion attributes
            if cast_ethnicity.ethnicity.region != None:
                approx_country = cast_ethnicity.ethnicity
            else:
                approx_country = Country.query.filter(
                    Country.demonym == cast_ethnicity.ethnicity.name).first()

            if approx_country != None:
                print(
                    f"{cast_ethnicity.ethnicity.name} is approximately in {approx_country.name}, {approx_country.subregion.name}, {approx_country.region.name}")

                if approx_country.name != 'Guyana':

                    if approx_country.region.name == 'Europe':
                        white = Race.query.filter(Race.short == 'WHT').one()
                        add_race_ids.add(white.id)

                    if approx_country.subregion.name in ['Central Asia', 'Western Asia']:
                        mena = Race.query.filter(Race.short == 'MENA').one()
                        add_race_ids.add(mena.id)

                    if approx_country.region.name == 'Africa' or approx_country.name in ['Haiti', 'Dominican Republic']:
                        black = Race.query.filter(Race.short == 'BLK').one()
                        add_race_ids.add(black.id)

                    if approx_country.subregion.name in ['Central America', 'South America'] or approx_country.name in ['Mexico', 'Puerto Rico', 'Cuba', 'Dominican Republic']:
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
                    f'Could not associate {cast_ethnicity.ethnicity.name} with a country')
                if cast_ethnicity.ethnicity.name in ['English', 'Cornish', 'Scottish', 'Welsh', 'Jewish']:
                    white = Race.query.filter(Race.short == 'WHT').one()
                    add_race_ids.add(white.id)
                if cast_ethnicity.ethnicity.name in ['African American', 'African', 'Guyanese']:
                    black = Race.query.filter(Race.short == 'BLK').one()
                    add_race_ids.add(black.id)
                if cast_ethnicity.ethnicity.name in ['Korean']:
                    asian = Race.query.filter(Race.short == 'ASN').one()
                    add_race_ids.add(asian.id)
                if cast_ethnicity.ethnicity.name == 'Hawaiian':
                    nhpi = Race.query.filter(Race.short == 'NHPI').one()
                    add_race_ids.add(nhpi.id)

        for race in add_race_ids:
            new_race = Race.query.filter(Race.id == race).one()
            if race in existing_races:
                print(f"Skipping {new_race.name}... already stored...")
                continue
            else:
                print(f"Adding {new_race.name} as a race...")
                new_person.races.append(new_race)


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


def update_cast_member(person_obj, person_order):
    curr_person = CastMember.query.filter(CastMember.id == person_obj.id).first()
    if curr_person != None and person_order < 10:
        # Add/Update ethnicity data
        add_ethnicity_data(curr_person)

        # Add race data
        add_race_data(curr_person)


def add_cast_member(person):
    """Add cast member information from api call."""
    if type(person) == str:
        print(f"Making api call...")
        url = f"https://api.themoviedb.org/3/search/person?query={person}&api_key={key}&language=en-US"
        response = requests.get(url)
        results = response.json()

        url = f"https://api.themoviedb.org/3/person/{results['results'][0]['id']}?api_key={key}"
        response = requests.get(url)
        person = response.json()

    new_person = CastMember.query.filter(CastMember.id == person['id']).first()
    if new_person == None:

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
                                biography=person['biography'],
                                profile_path=person['profile_path'])

        if len(person['also_known_as']) > 0:
            for aka in person['also_known_as']:
                new_aka = AlsoKnownAs.query.filter(AlsoKnownAs.name == aka).first()
                if new_aka == None:
                    new_aka = AlsoKnownAs(name=aka)
                    new_person.also_known_as.append(new_aka)
                    print(f"Added alternative name {new_aka.name} for {new_person.name}")

    # Add gender data
    if person.get("gender", None) is not None:
        id = person["gender"]
        gender_object = Gender.query.filter(Gender.id == id).one()
        new_person.gender = gender_object

    # Add country_of_birth data
    if person.get("place_of_birth", None) is not None:
        country = person["place_of_birth"].split(',')
        country_object = Country.query.join(AltCountry).filter(
            (Country.id == country[-1].strip()) | (Country.name == country[-1].strip()) | (AltCountry.alt_name == country[-1].strip())).first()
        new_person.country_of_birth = country_object

    if person['order'] < 10:
        # Add ethnicity data
        add_ethnicity_data(new_person)

        # Add race data
        add_race_data(new_person)

    return new_person


def add_credits(credit_list, curr_movie):
    """Add credits for a given credit list for a movie."""

    new_credits = []
    for cast in credit_list:
        cast_member = CastMember.query.filter(
            CastMember.id == cast["id"]).one()
        new_credit = Credit.query.filter_by(id=cast["credit_id"]).first()
        if new_credit == None:
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

    query = Movie.query.filter(func.lower(Movie.title).like(
        f'{keywords.lower()}%')).order_by(desc(Movie.release_date)).all()
    return query


def query_movie_credits(movie_obj):
    """Return search query results."""

    query = Credit.query.filter(Credit.movie == movie_obj).all()
    return query


def query_cast(keywords):
    """Return search query results for a cast member."""

    query = CastMember.query.filter(func.lower(CastMember.name).like(
        f'%{keywords.lower()}%')).all()
    return query


def query_api_movie(keywords):
    """Return search query results from api."""

    # filters = [func.lower(Movie.title).like(
    #     f'%{keyword.lower()}%') for keyword in keywords]
    query = Movie.query.filter(func.lower(Movie.title).like(
        f'{keywords.lower()}%')).all()

    if len(query) < 10:
        print("Not enough results in db...\nMaking API call...")
        response = requests.get(
            f'https://api.themoviedb.org/3/search/movie?api_key={key}&query={keywords}')
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
    print(f"Retrieved movie details...")
    return movie_details


def query_api_credits(movie_id):
    """Return cast credit list of a given movie."""

    url = f"https://api.themoviedb.org/3/movie/{movie_id}/credits?api_key={key}&language=en-US"
    response = requests.get(url)
    movie_credits = response.json()
    print(f"Retrieved credits...\n")

    return movie_credits['cast']


def query_api_people(credit_list, movie_title):
    """Create cast members for given list of credits."""

    update_count = 0
    add_count = 0
    for person in credit_list:
        if type(person) == dict:
            person_query = CastMember.query.filter(
                CastMember.id == person['id']).first()
        else:
            person_query = CastMember.query.filter(
                CastMember.id == person.cast_member.id).first()

        if person_query == None:
            print(
                f"{person['name']} doesn't exist in database...\nMaking api call...")
            url = f"https://api.themoviedb.org/3/person/{person['id']}?api_key={key}"
            response = requests.get(url)
            person = response.json()

            cast_member = add_cast_member(person, person['order'])
            db.session.add(cast_member)
            add_count += 1

        else:
            update_cast_member(person_query, person['order'])
            update_count += 1

        if person['order'] < 10:
            print("Sleeping for 5 seconds...\n")
            time.sleep(5)

    db.session.commit()

    if add_count > 0:
        print(f"Added {add_count} cast to db!")
    if update_count > 0:
        print(f"Updated {update_count} cast in db!")


def get_movie_cast(movie_id):
    """Return specific movie with credits and cast member details."""

    movie = Movie.query.filter(Movie.id == movie_id).one()
    if movie.imdb_id == None:
        print(f"Movie details are missing...\nMaking api call...\n")

        # Update movie
        movie_details = query_api_movie_details(movie_id)
        update_movie_with_movie_details(movie, movie_details)

        # Get cast list and add cast members
        cast_credit_list = query_api_credits(movie_id)
        query_api_people(cast_credit_list, movie.title)

        # Add credits after adding cast members
        add_credits(cast_credit_list, movie)

    cast_list = db.session.query(
        CastMember,
        Gender,
        Country,
        Credit).join(
        Credit, Credit.cast_member_id == CastMember.id, isouter=True).join(
        Gender, Gender.id == CastMember.gender_id, isouter=True).join(
        Country, Country.id == CastMember.country_of_birth_id, isouter=True).join(
        Movie, Movie.id == Credit.movie_id, isouter=True).filter(
        Movie.id == movie_id).filter(Credit.order < 10).order_by(
        Credit.order).all()

    cast_details = []

    for cast in cast_list:
        cast_member = CastMember.query.filter(
            CastMember.id == cast.CastMember.id).one()

        ethnicities = []
        for cast_ethnicity in cast_member.ethnicities:
            ethnicities.append({
                'name': cast_ethnicity.ethnicity.name,
                'sources': [source.link for source in cast_ethnicity.sources]
            })

        races = [race.name for race in cast_member.races]

        new_cast = {'name': cast.CastMember.name,
                    'birthday': cast.CastMember.birthday,
                    'gender': cast.Gender.name,
                    'ethnicity': ethnicities,
                    'race': races,
                    'country_of_birth': cast.Country.name if cast.Country else None,
                    'character': cast.Credit.character,
                    'order': cast.Credit.order,
                    'profile_path': cast.CastMember.profile_path}
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
    print(f"Fetching details about {data['title']}...")
    return data


if __name__ == '__main__':
    from app import app
    connect_to_db(app)
