"""Script to seed database."""

import os
import json
import time

import server
from model import db, connect_to_db, Region, SubRegion, Country, AltCountry, Movie, Genre, Gender, Ethnicity, AltEthnicity, Race, CastMember, Credit
from data.ethnicity import *
from datetime import datetime


def seed_regions():
    """Seed regions table with region information."""

    region_list = ['Africa', 'Americas',
                   'Antarctic', 'Asia', 'Europe', 'Oceania']
    add_regions = []
    for region in region_list:
        new_region = Region(name=region)
        add_regions.append(new_region)

    db.session.add_all(add_regions)
    db.session.commit()
    print(f"Added {len(add_regions)} regions to db!")


def seed_subregions(file_path='data/regions.json'):
    """Seed subregion table with subregion information."""

    with open(file_path, 'r') as file:
        data = json.load(file)

        subregion_list = []
        for subregion in data:
            region = Region.query.filter(
                Region.name == subregion['region']).one()
            new_region = SubRegion(
                name=subregion['subregion'], region_id=region, region=region)
            subregion_list.append(new_region)

    db.session.add_all(subregion_list)
    db.session.commit()
    print(f"Added {len(subregion_list)} subregions to db!")


def seed_countries(file_path='data/countries.json'):
    """Seed countries table with country information."""

    countries_list = []
    with open(file_path, 'r') as file:
        data = json.load(file)
        for country in data:
            if country.get("demonyms", None) is None:
                demonym = "Unknown"
            else:
                demonym = country["demonyms"]["eng"]["f"]

            region = Region.query.filter(
                Region.name == country['region']).one()
            subregion = SubRegion.query.filter(
                SubRegion.name == country['subregion']).one()

            new_country = Country(id=country['cca3'],
                                  name=country["name"]["common"],
                                  demonym=demonym,
                                  region_id=region,
                                  subregion_id=subregion,
                                  region=region,
                                  subregion=subregion)

            for alt_spelling in country["altSpellings"]:
                new_alt_spelling = AltCountry(country_id=new_country,
                                              alt_name=alt_spelling)
                new_country.alt_names.append(new_alt_spelling)

            countries_list.append(new_country)

    db.session.add_all(countries_list)
    db.session.commit()
    print(f"Added {len(countries_list)} countries to db!")


def seed_ethnicities(file_path='data/ethnicities.json'):
    """Seed ethnicities table with ethnicity information."""

    with open(file_path, 'r') as file:
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

                if type(ethnicity) == dict:
                    subregion = SubRegion.query.filter(
                        SubRegion.name == ethnicity['subregion']).one()
                    new_ethnicity = Ethnicity(
                        name=ethnicity['name'], subregion=subregion, region=subregion.region)
                else:
                    if "/" in ethnicity:
                        ethnicity_split = ethnicity.split("/")
                        new_ethnicity = Ethnicity(name=ethnicity_split[0])
                        for alt_ethnicity_name in ethnicity_split[1:]:
                            alt_ethnicity = AltEthnicity(
                                alt_name=alt_ethnicity_name, ethnicity_id=new_ethnicity)
                            new_ethnicity.alt_names.append(alt_ethnicity)
                    else:
                        new_ethnicity = Ethnicity(name=ethnicity)

                ethnicities_list.append(new_ethnicity)

    db.session.add_all(ethnicities_list)
    db.session.commit()
    print(f"Added {len(ethnicities_list)} ethnicities to db!")


def seed_races(file_path='data/race.json'):
    """Seed race table with race information from the US census."""

    with open(file_path, 'r') as file:
        data = json.load(file)

        race_list = []
        for race in data:
            new_race = Race(name=race['name'],
                            short=race['short'],
                            description=race['description'])

            race_list.append(new_race)

    db.session.add_all(race_list)
    db.session.commit()
    print(f"Added {len(race_list)} races to db!")


def seed_genders():
    """Seed genders table in database."""

    gender_list = ['Unknown', 'Female', 'Male', 'Non-Binary']
    genders_in_db = []
    for i in range(len(gender_list)):
        new_gender = Gender(id=i, name=gender_list[i])
        genders_in_db.append(new_gender)

    db.session.add_all(genders_in_db)
    db.session.commit()
    print(f'Added {len(genders_in_db)} genders to db!')


def seed_genres(file_path='data/genres.json'):
    """Seed genres table in database."""

    with open(file_path) as file:
        genre_list = json.loads(file.read())

    genres_in_db = []
    for genre in genre_list["genres"]:
        new_genre = Genre(id=genre["id"],
                          name=genre["name"])
        genres_in_db.append(new_genre)

    db.session.add_all(genres_in_db)
    db.session.commit()
    print(f"Added {len(genres_in_db)} genres to db!")


def seed_movies(file_path='data/movie_details.json'):
    """Seed movies table in database."""

    with open(file_path) as file:
        movie_data = json.loads(file.read())

    movies_in_db = []

    for movie in movie_data:
        format = "%Y-%m-%d"
        formatted_date = datetime.strptime(movie['release_date'], format)
        new_movie = Movie(id=movie["id"],
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
            genre_object = Genre.query.filter(Genre.id == id).one()
            new_movie.genres.append(genre_object)

    db.session.add_all(movies_in_db)
    db.session.commit()
    print(f"Added {len(movies_in_db)} movies to db!")


def seed_cast_members(file_path='data/persons.json'):
    """Seed cast_members table in database."""

    with open(file_path) as file:
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

        new_person = CastMember(id=person['id'],
                                imdb_id=person['imdb_id'],
                                name=person['name'],
                                birthday=formatted_bday,
                                deathday=formatted_dday,
                                biography=person['biography']
                                )
        persons_in_db.append(new_person)

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

    db.session.add_all(persons_in_db)
    db.session.commit()
    print(f"Added {len(persons_in_db)} cast members to db!")


def seed_credits(file_path='data/credits.json'):
    """Seed credits table in database."""

    with open(file_path) as file:
        credits_data = json.loads(file.read())

    credits_in_db = []
    for movie in credits_data:
        curr_movie = Movie.query.filter(Movie.id == movie['id']).one()
        for cast in movie['cast'][:15]:
            cast_member = CastMember.query.filter(
                CastMember.id == cast["id"]).one()
            new_credit = Credit(id=cast["credit_id"],
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


if __name__ == '__main__':
    os.system("dropdb demographix")
    os.system("createdb demographix")

    connect_to_db(server.app)
    db.create_all()

    seed_regions()
    seed_subregions()
    seed_countries()
    seed_ethnicities()
    seed_races()
    seed_genders()
    seed_genres()
    seed_movies()
    seed_cast_members()
    seed_credits()
