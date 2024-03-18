"""CRUD operations."""

import logging
import os
from datetime import datetime

import requests
from data.ethnicity import get_ethnicity
from data.nominations import check_nominations
from model import (
    AlsoKnownAs,
    AltCountry,
    AltEthnicity,
    CastEthnicity,
    CastMember,
    Country,
    Credit,
    Ethnicity,
    Gender,
    Genre,
    Movie,
    MovieNomination,
    Nomination,
    Race,
    Source,
    SourceLink,
    connect_to_db,
    db,
)
from sqlalchemy import and_, create_engine, desc, exc, func
from sqlalchemy.orm import sessionmaker

key = os.environ["TMDB_API_KEY"]
access_token = os.environ["TMDB_ACCESS_TOKEN"]


def add_new_movie(movie_id):
    db_uri = "postgresql:///demographix"
    if os.environ["FLASK_ENV"] == "production":
        db_uri = os.environ["DB_URI"]
    engine = create_engine(db_uri)
    Session = sessionmaker(bind=engine)
    session = Session()
    try:
        with session.no_autoflush:
            logging.info("missing... making api call...\n")
            url = f"https://api.themoviedb.org/3/movie/{movie_id}?language=en-US"
            headers = {
                "accept": "application/json",
                "Authorization": f"Bearer {access_token}",
            }
            response = requests.get(url, headers=headers)
            movie = response.json()

            formatted_date = None
            logging.info(movie["release_date"])
            if len(movie["release_date"]) > 0:
                format = "%Y-%m-%d"
                formatted_date = datetime.strptime(movie["release_date"], format)
            new_movie = Movie(
                id=movie["id"],
                title=movie["title"],
                overview=movie["overview"],
                poster_path=movie["poster_path"],
                release_date=formatted_date,
                imdb_id=movie["imdb_id"],
                runtime=movie["runtime"],
                budget=movie["budget"],
                revenue=movie["revenue"],
            )
            logging.info(f"Created new movie: {new_movie}")
            for genre in movie["genres"]:
                genre_object = Genre.query.filter(Genre.id == genre["id"]).one()
                new_movie.genres.append(genre_object)

            db.session.add(new_movie)
            db.session.commit()

            # Get cast list and add cast members
            cast_credit_list = query_api_credits(movie_id)
            query_api_people(cast_credit_list)

            # Add credits after adding cast members
            add_credits(cast_credit_list, new_movie)

    except exc.IntegrityError as e:
        logging.error(e)
        session.rollback()
    finally:
        session.close()


def add_nomination(movie: Movie, year: int, award="Academy Awards"):
    nomination = Nomination.query.filter(
        and_(Nomination.name == award, Nomination.year == year)
    ).first()

    if nomination is None:
        nomination = Nomination(name="Academy Awards", year=year)
        logging.info(
            "Adding %s %s to db...",
            nomination.name,
            nomination.year,
        )

    movie.nominations.append(nomination)
    date_format = "%Y"

    logging.info(
        f"Adding {nomination.name} {nomination.year} nomination for {movie.title} ({movie.release_date.strftime(date_format)})"
    )


def add_source_data(new_person, ethnicity_object, source):
    formatted_source = "/".join(source.split("/")[0:3])

    original_source = Source.query.filter(
        Source.domain.like(f"%{formatted_source}%")
    ).first()

    if original_source is None:
        original_source = Source(
            name=f"{formatted_source.split('.')[-2].capitalize()}",
            domain=f"{formatted_source}",
        )
        db.session.add(original_source)
        logging.info(f"Adding new source: {original_source.name} to db!")

    new_source_link = SourceLink.query.filter(SourceLink.link == source).first()
    if new_source_link is None:
        new_source_link = SourceLink(link=source, source_id=original_source.id)
        db.session.add(new_source_link)
        logging.info(f"Adding new source link: {new_source_link.link} to db!")

    cast_ethnicity = CastEthnicity.query.filter(
        and_(
            CastEthnicity.cast_member_id == new_person.id,
            CastEthnicity.ethnicity_id == ethnicity_object.id,
        )
    ).first()
    if cast_ethnicity is None:
        cast_ethnicity = CastEthnicity(
            ethnicity_id=ethnicity_object.id,
            cast_member_id=new_person.id,
            ethnicity=ethnicity_object,
        )
        db.session.add(cast_ethnicity)

    if new_source_link not in cast_ethnicity.sources:
        cast_ethnicity.sources.append(new_source_link)
        logging.info(
            f"Added new ref link: {new_source_link.link} for {ethnicity_object.name} ethnicity for {new_person.name}"
        )

    return cast_ethnicity


def add_ethnicity_data(new_person):
    logging.info(f"Finding ethnicity information about {new_person.name}...")
    results = get_ethnicity(new_person)
    if results.get("list", None) is not None:
        ethnicity_list = results["list"]
        source = results["source"]

        # Check for duplicates
        existing_ethnicities = set([])
        for cast_ethnicity in new_person.ethnicities:
            existing_ethnicities.add(cast_ethnicity.ethnicity.id)
            # Update existing ethnicity sources
            if (
                len(cast_ethnicity.sources) == 0
                and cast_ethnicity.ethnicity.name in ethnicity_list
            ):
                add_source_data(new_person, cast_ethnicity.ethnicity, source)

        # Add new ethnicities
        for ethnicity in ethnicity_list:
            ethnicity_object = (
                Ethnicity.query.outerjoin(AltEthnicity)
                .filter(
                    (Ethnicity.name == ethnicity) | (AltEthnicity.alt_name == ethnicity)
                )
                .first()
            )

            if ethnicity_object is not None:
                # Query/Add source
                cast_ethnicity = add_source_data(new_person, ethnicity_object, source)

                if ethnicity_object.id in existing_ethnicities:
                    logging.info(
                        f"Skipping {ethnicity_object.name}... already stored..."
                    )
                    continue
                else:
                    new_person.ethnicities.append(cast_ethnicity)
                    logging.info(
                        f"Adding {cast_ethnicity.ethnicity.name} to {new_person.name}"
                    )
    else:
        logging.info("No ethnicity information found...")

    logging.info("\n")


def add_race_data(new_person):
    logging.info("Adding approximate race data...")
    if len(new_person.ethnicities) == 0:
        logging.info("Cannot approximate race data without ethnicity data...\n")
        return

    else:
        existing_races = set()
        for races in new_person.races:
            existing_races.add(races.id)

        add_race_ids = set()
        for cast_ethnicity in new_person.ethnicities:
            # If region is specified in ethnicity, set approx_country to that ethnicity which has region and subregion attributes. Otherwise, query a country object which also has region and subregion attributes
            if cast_ethnicity.ethnicity.region is not None:
                approx_country = cast_ethnicity.ethnicity
            else:
                approx_country = Country.query.filter(
                    Country.demonym == cast_ethnicity.ethnicity.name
                ).first()

            if approx_country is not None:
                logging.info(
                    f"{cast_ethnicity.ethnicity.name} is approximately in {approx_country.name}, {approx_country.subregion.name}, {approx_country.region.name}"
                )

                if approx_country.name != "Guyana":

                    if approx_country.region.name == "Europe":
                        white = Race.query.filter(Race.short == "WHT").one()
                        add_race_ids.add(white.id)

                    if approx_country.subregion.name in [
                        "Central Asia",
                        "Western Asia",
                    ]:
                        mena = Race.query.filter(Race.short == "MENA").one()
                        add_race_ids.add(mena.id)

                    if (
                        approx_country.region.name == "Africa"
                        or approx_country.name
                        in ["Haiti", "Dominican Republic", "Trinidad and Tobago"]
                    ):
                        black = Race.query.filter(Race.short == "BLK").one()
                        add_race_ids.add(black.id)

                    if approx_country.subregion.name in [
                        "Central America",
                        "South America",
                    ] or approx_country.name in [
                        "Mexico",
                        "Puerto Rico",
                        "Cuba",
                        "Dominican Republic",
                    ]:
                        hispanic = Race.query.filter(Race.short == "HSPN").one()
                        add_race_ids.add(hispanic.id)

                    if approx_country.subregion.name in [
                        "Eastern Asia",
                        "South-Eastern Asia",
                        "Southern Asia",
                    ]:
                        asian = Race.query.filter(Race.short == "ASN").one()
                        add_race_ids.add(asian.id)

                    if approx_country.subregion.name in [
                        "Polynesia",
                        "Micronesia",
                        "Melanesia",
                    ]:
                        nhpi = Race.query.filter(Race.short == "NHPI").one()
                        add_race_ids.add(nhpi.id)

            else:
                logging.info(
                    f"Could not associate {cast_ethnicity.ethnicity.name} with a country"
                )
                if cast_ethnicity.ethnicity.name in [
                    "English",
                    "Cornish",
                    "Scottish",
                    "Welsh",
                    "Jewish",
                ]:
                    white = Race.query.filter(Race.short == "WHT").one()
                    add_race_ids.add(white.id)
                if cast_ethnicity.ethnicity.name in [
                    "African American",
                    "African",
                    "Guyanese",
                ]:
                    black = Race.query.filter(Race.short == "BLK").one()
                    add_race_ids.add(black.id)
                if cast_ethnicity.ethnicity.name in ["Korean"]:
                    asian = Race.query.filter(Race.short == "ASN").one()
                    add_race_ids.add(asian.id)
                if cast_ethnicity.ethnicity.name == "Hawaiian":
                    nhpi = Race.query.filter(Race.short == "NHPI").one()
                    add_race_ids.add(nhpi.id)

        for race in add_race_ids:
            new_race = Race.query.filter(Race.id == race).one()
            if race in existing_races:
                logging.info(f"Skipping {new_race.name}... already stored...")
                continue
            else:
                logging.info(f"Adding {new_race.name} as a race...")
                new_person.races.append(new_race)

        logging.info("\n\n\n")


def get_regions():
    """Return all regions and subregions"""

    logging.info(
        db.session.query(Country.subregion, Country.region)
        .group_by(Country.subregion, Country.region)
        .order_by(Country.subregion.asc())
        .all()
    )
    return (
        db.session.query(Country.subregion, Country.region)
        .group_by(Country.subregion, Country.region)
        .order_by(Country.subregion.asc())
        .all()
    )


def get_movies():
    """Return all movies."""

    return Movie.query.all()


def add_movie_from_search(movie):
    formatted_date = None
    if len(movie["release_date"]) > 0:
        format = "%Y-%m-%d"
        formatted_date = datetime.strptime(movie["release_date"], format)
    new_movie = Movie(
        id=movie["id"],
        title=movie["title"],
        overview=movie["overview"],
        poster_path=movie["poster_path"],
        release_date=formatted_date,
    )
    logging.info(f"Created new movie: {new_movie}")
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

    logging.info(f"Updated existing movie: {movie.title}")


def update_cast_member(person_obj, person_order):
    curr_person = CastMember.query.filter(CastMember.id == person_obj.id).first()
    if curr_person is not None and person_order < 10:
        # Add/Update ethnicity data
        add_ethnicity_data(curr_person)

        # Add race data
        add_race_data(curr_person)


def add_cast_member(person, order):
    """Add cast member information from api call."""
    if isinstance(person) == str:
        logging.info("Making api call...")
        url = f"https://api.themoviedb.org/3/search/person?query={person}&api_key={key}&language=en-US"
        response = requests.get(url)
        results = response.json()

        url = f"https://api.themoviedb.org/3/person/{results['results'][0]['id']}?api_key={key}"
        response = requests.get(url)
        person = response.json()

    new_person = CastMember.query.filter(CastMember.id == person["id"]).first()
    if new_person is None:

        # Add basic cast member data
        format = "%Y-%m-%d"
        formatted_bday = None
        if person["birthday"] is not None:
            formatted_bday = datetime.strptime(person["birthday"], format)

        formatted_dday = None
        if person["deathday"] is not None:
            formatted_dday = datetime.strptime(person["deathday"], format)

        new_person = CastMember(
            id=person["id"],
            imdb_id=person["imdb_id"],
            name=person["name"],
            birthday=formatted_bday,
            deathday=formatted_dday,
            biography=person["biography"],
            profile_path=person["profile_path"],
        )

        if len(person["also_known_as"]) > 0:
            for aka in person["also_known_as"]:
                new_aka = AlsoKnownAs.query.filter(AlsoKnownAs.name == aka).first()
                if new_aka is None:
                    new_aka = AlsoKnownAs(name=aka)
                    new_person.also_known_as.append(new_aka)
                    logging.info(
                        f"Added alternative name {new_aka.name} for {new_person.name}"
                    )

    # Add gender data
    if person.get("gender", None) is not None:
        id = person["gender"]
        gender_object = Gender.query.filter(Gender.id == id).one()
        new_person.gender = gender_object

    db.session.add(new_person)
    db.session.commit()

    # Add country_of_birth data
    if person.get("place_of_birth", None) is not None:
        country = person["place_of_birth"].split(",")
        country_object = (
            Country.query.join(AltCountry)
            .filter(
                (Country.id == country[-1].strip())
                | (Country.name == country[-1].strip())
                | (AltCountry.alt_name == country[-1].strip())
            )
            .first()
        )
        new_person.country_of_birth = country_object

    if order < 10:
        # Add ethnicity data
        add_ethnicity_data(new_person)

        # Add race data
        add_race_data(new_person)

    return new_person


def add_credits(credit_list, curr_movie):
    """Add credits for a given credit list for a movie."""

    new_credits = []
    for cast in credit_list:
        cast_member = CastMember.query.filter(CastMember.id == cast["id"]).one()
        new_credit = Credit.query.filter_by(id=cast["credit_id"]).first()
        if new_credit is None:
            new_credit = Credit(
                id=cast["credit_id"],
                movie_id=curr_movie,
                character=cast["character"],
                order=cast["order"],
                cast_member_id=cast_member,
                movie=curr_movie,
                cast_member=cast_member,
            )

            new_credits.append(new_credit)

    db.session.add_all(new_credits)
    db.session.commit()
    logging.info(f"Added {len(new_credits)} credits to db!")


def query_movie(keywords):
    """Return search query results."""

    if keywords == "":
        query = (
            Movie.query.join(Movie.credits)
            .filter(Movie.poster_path is not None)
            .group_by(Movie.id)
            .having(func.count(Movie.credits) > 1)
            .order_by(func.random())
            .all()
        )
        return query[:30]

    else:
        keyword_query = (
            Movie.query.join(Movie.credits)
            .group_by(Movie.id)
            .having(func.count(Movie.credits) > 1)
            .filter(
                and_(
                    func.lower(Movie.title).like(f"{keywords.lower()}%"),
                    Movie.poster_path is not None,
                )
            )
            .order_by(desc(Movie.release_date))
        )
        if len(keyword_query.all()) < 5:
            keyword_query = query_api_movie(keywords)
        additional_query = (
            Movie.query.join(Movie.credits)
            .filter(Movie.poster_path is not None)
            .group_by(Movie.id)
            .having(func.count(Movie.credits) > 1)
            .order_by(Movie.title.like(f"{keywords[0].lower()}%"))
        )

        combined_query = keyword_query.union_all(additional_query)
        results = combined_query.all()

        return results[:28]


def query_movie_credits(movie_obj):
    """Return search query results."""

    query = Credit.query.filter(Credit.movie == movie_obj).all()
    return query


def query_cast(keywords):
    """Return search query results for a cast member."""

    query = CastMember.query.filter(
        func.lower(CastMember.name).like(f"%{keywords.lower()}%")
    ).all()
    return query


def query_api_movie(keywords):
    """Return search query results from api."""

    logging.info("Not enough results in db...\nMaking API call...")
    response = requests.get(
        f"https://api.themoviedb.org/3/search/movie?api_key={key}&query={keywords}"
    )
    result_list = response.json()
    movies = result_list["results"]
    logging.info(f'Found {len(movies)} movies with query "{keywords}"')

    new_movies = []
    for movie in movies:
        curr_movie = Movie.query.filter(Movie.id == movie["id"]).first()
        if curr_movie is None:
            curr_movie = add_movie_from_search(movie)
            new_movies.append(curr_movie)
            logging.info(f"Adding new move to db: {curr_movie}...\n")

    db.session.add_all(new_movies)
    db.session.commit()
    logging.info(f"Added {len(new_movies)} movies to db!")

    query = Movie.query.filter(
        func.lower(Movie.title).like(f"{keywords.lower()}%")
    ).order_by(desc(Movie.release_date))

    return query


def query_api_movie_details(movie_id):
    url = f"https://api.themoviedb.org/3/movie/{movie_id}?language=en-US"
    headers = {"accept": "application/json", "Authorization": f"Bearer {access_token}"}
    response = requests.get(url, headers=headers)
    movie_details = response.json()
    logging.info("Retrieved movie details...")
    return movie_details


def query_api_credits(movie_id):
    """Return cast credit list of a given movie."""

    url = f"https://api.themoviedb.org/3/movie/{movie_id}/credits?api_key={key}&language=en-US"
    response = requests.get(url)
    movie_credits = response.json()
    logging.info("Retrieved credits...\n")

    return movie_credits["cast"]


def query_api_people(credit_list):
    """Create cast members for given list of credits."""

    update_count = 0
    add_count = 0
    for person in credit_list:
        if isinstance(person) == dict:
            person_query = CastMember.query.filter(
                CastMember.id == person["id"]
            ).first()
        else:
            person_query = CastMember.query.filter(
                CastMember.id == person.cast_member.id
            ).first()

        if person_query is None:
            logging.info(
                f"{person['name']} doesn't exist in database... making api call..."
            )
            url = f"https://api.themoviedb.org/3/person/{person['id']}?api_key={key}"
            response = requests.get(url)
            person_details = response.json()

            add_cast_member(person_details, person["order"])
            add_count += 1

        else:
            update_cast_member(person_query, person["order"])
            update_count += 1

        # if person['order'] < 10:
        #     logging.info("Sleeping for 5 seconds...\n")
        #     time.sleep(5)

    db.session.commit()

    if add_count > 0:
        logging.info(f"Added {add_count} cast to db!")
    if update_count > 0:
        logging.info(f"Updated {update_count} cast in db!")


def get_movie_cast(movie_id):
    """Return specific movie with credits and cast member details."""

    movie = Movie.query.filter(Movie.id == movie_id).one()
    if movie.imdb_id is None:
        logging.info("Movie details are missing...\nMaking api call...\n")

        # Update movie
        movie_details = query_api_movie_details(movie_id)
        update_movie_with_movie_details(movie, movie_details)

        # Get cast list and add cast members
        cast_credit_list = query_api_credits(movie_id)
        query_api_people(cast_credit_list)

        # Add credits after adding cast members
        add_credits(cast_credit_list, movie)

    cast_list = (
        db.session.query(CastMember, Gender, Country, Credit)
        .join(Credit, Credit.cast_member_id == CastMember.id, isouter=True)
        .join(Gender, Gender.id == CastMember.gender_id, isouter=True)
        .join(Country, Country.id == CastMember.country_of_birth_id, isouter=True)
        .join(Movie, Movie.id == Credit.movie_id, isouter=True)
        .filter(Movie.id == movie_id)
        .filter(Credit.order < 15)
        .order_by(Credit.order)
        .all()
    )

    cast_details = []

    for cast in cast_list:
        cast_member = CastMember.query.filter(CastMember.id == cast.CastMember.id).one()

        ethnicities = []
        for cast_ethnicity in cast_member.ethnicities:
            ethnicities.append(
                {
                    "name": cast_ethnicity.ethnicity.name,
                    "sources": [source.link for source in cast_ethnicity.sources],
                }
            )

        races = [race.name for race in cast_member.races]

        new_cast = {
            "id": cast.CastMember.id,
            "name": cast.CastMember.name,
            "birthday": cast.CastMember.birthday,
            "gender": cast.Gender.name,
            "ethnicity": ethnicities,
            "race": races,
            "country_of_birth": cast.Country.id if cast.Country else None,
            "character": cast.Credit.character,
            "order": cast.Credit.order,
            "profile_path": cast.CastMember.profile_path,
        }
        cast_details.append(new_cast)

    genre_list = [genre.name for genre in movie.genres]

    data = {
        "id": movie.id,
        "title": movie.title,
        "genres": genre_list,
        "overview": movie.overview,
        "runtime": movie.runtime,
        "poster_path": movie.poster_path,
        "release_date": movie.release_date,
        "budget": movie.budget,
        "revenue": movie.revenue,
        "cast": cast_details,
    }
    logging.info(f"Fetching details about {data['title']}...")
    return data


def get_nom_movies(year):
    """Return nominated movies and cast demographgics for a given year"""

    nomination = Nomination.query.filter(Nomination.year == year).first()
    movie_noms = MovieNomination.query.filter(
        MovieNomination.nomination_id == nomination.id
    ).all()
    if len(movie_noms) < 5:
        check_nominations(int(year))
        movie_noms = MovieNomination.query.filter(
            MovieNomination.nomination_id == nomination.id
        ).all()
        logging.info(len(movie_noms))

    all_movie_data = []
    for movie_nom in movie_noms:
        movie_data = get_movie_cast(movie_nom.movie_id)
        all_movie_data.append(movie_data)

    return all_movie_data


if __name__ == "__main__":
    from app import app

    connect_to_db(app)
