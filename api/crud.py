"""CRUD operations."""

import logging
import os
from datetime import datetime

import requests
from data.cast import add_ethnicity_data, add_race_data, update_cast_member
from model import (AlsoKnownAs, AltCountry, CastMember, Country, Credit,
                   Gender, Genre, Movie, Nomination, db)
from sqlalchemy import and_, create_engine, desc, exc, func
from sqlalchemy.orm import sessionmaker

key = os.environ["TMDB_API_KEY"]
access_token = os.environ["TMDB_ACCESS_TOKEN"]


def add_new_movie(movie_id):
    db_uri = "postgresql:///demographix"
    if os.environ["FLASK_ENV"] == "production":
        db_uri = os.environ["DB_URI"]
    engine = create_engine(db_uri)
    # Session = sessionmaker(bind=engine)
    session = sessionmaker(bind=engine)()
    try:
        with session.no_autoflush:
            session.begin()

            logging.info("missing... making api call...\n")
            response = requests.get(
                f"https://api.themoviedb.org/3/movie/{movie_id}?language=en-US",
                headers={
                    "accept": "application/json",
                    "Authorization": f"Bearer {access_token}",
                },
                timeout=15,
            )
            movie = response.json()

            formatted_date = None
            logging.info(movie["release_date"])
            if len(movie["release_date"]) > 0:
                date_format = "%Y-%m-%d"
                formatted_date = datetime.strptime(movie["release_date"], date_format)
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
            logging.info("Created new movie: %s", new_movie)
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
        nomination = Nomination(name=award, year=year)
        logging.info(
            "Adding %s %s to db...",
            nomination.name,
            nomination.year,
        )

    movie.nominations.append(nomination)
    date_format = "%Y"

    logging.info(
        "Adding %s %s nomination for %s (%s)",
        nomination.name,
        nomination.year,
        movie.title,
        movie.release_date.strftime(date_format),
    )


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
        date_format = "%Y-%m-%d"
        formatted_date = datetime.strptime(movie["release_date"], date_format)
    new_movie = Movie(
        id=movie["id"],
        title=movie["title"],
        overview=movie["overview"],
        poster_path=movie["poster_path"],
        release_date=formatted_date,
    )
    logging.info("Created new movie: %s", new_movie)
    for genre_id in movie["genre_ids"]:
        genre_object = Genre.query.filter(Genre.id == genre_id).one()
        new_movie.genres.append(genre_object)
    return new_movie


def add_cast_member(person, order):
    """Add cast member information from api call."""
    if isinstance(person, str):
        logging.info("Making api call...")
        response = requests.get(
            str.format(
                "https://api.themoviedb.org/3/search/person?query={}&api_key={}&language=en-US",
                person,
                key,
            ),
            timeout=15,
        )
        results = response.json()

        response = requests.get(
            str.format(
                "https://api.themoviedb.org/3/person/{}?api_key={}",
                results["results"][0]["id"],
                key,
            ),
            timeout=15,
        )
        person = response.json()

    new_person = CastMember.query.filter(CastMember.id == person["id"]).first()
    if new_person is None:
        # Add basic cast member data
        date_format = "%Y-%m-%d"
        formatted_bday = None
        if person["birthday"] is not None:
            formatted_bday = datetime.strptime(person["birthday"], date_format)

        formatted_dday = None
        if person["deathday"] is not None:
            formatted_dday = datetime.strptime(person["deathday"], date_format)

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
                        "Added alternative name %s for %s",
                        new_aka.name,
                        new_person.name,
                    )

    # Add gender data
    if person.get("gender", None) is not None:
        gender_object = Gender.query.filter(Gender.id == person["gender"]).one()
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
    logging.info("Added %s credits to db!", len(new_credits))


def query_movie(keywords):
    """Return search query results."""
    if keywords == "":
        query = (
            Movie.query.join(Movie.credits)
            .filter(Movie.poster_path is not None)
            .group_by(
                Movie.id,
                Movie.imdb_id,
                Movie.title,
                Movie.overview,
                Movie.runtime,
                Movie.poster_path,
                Movie.release_date,
                Movie.budget,
                Movie.revenue,
            )
            .having(func.count(Movie.credits) > 1)
            .order_by(func.random())
            .all()
        )
        return query[:30]

    else:
        keyword_query = (
            Movie.query.join(Movie.credits)
            .group_by(
                Movie.id,
                Movie.imdb_id,
                Movie.title,
                Movie.overview,
                Movie.runtime,
                Movie.poster_path,
                Movie.release_date,
                Movie.budget,
                Movie.revenue,
            )
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
            .having((Movie.credits) > 1)
            .order_by(Movie.title.like(f"{keywords[0].lower()}%"))
        )

        combined_query = keyword_query.union_all(additional_query)
        results = combined_query.all()

        return results[:28]


def query_movie_credits(movie_obj):
    """Return search query results."""

    query = Credit.query.filter(Credit.movie == movie_obj).all()
    return query


def query_api_movie(keywords):
    """Return search query results from api."""

    logging.info("Not enough results in db... making API call...")
    response = requests.get(
        str.format(
            "https://api.themoviedb.org/3/search/movie?api_key={}&query={}",
            key,
            keywords,
        ),
        timeout=15,
    )
    result_list = response.json()
    movies = result_list["results"]
    logging.info('Found %s movies with query "%s"', len(movies), keywords)

    new_movies = []
    for movie in movies:
        curr_movie = Movie.query.filter(Movie.id == movie["id"]).first()
        if curr_movie is None:
            curr_movie = add_movie_from_search(movie)
            new_movies.append(curr_movie)
            logging.info("Adding new move to db: %s...\n", curr_movie)

    db.session.add_all(new_movies)
    db.session.commit()
    logging.info("Added %s movies to db!", len(new_movies))

    query = Movie.query.filter(
        func.lower(Movie.title).like(f"{keywords.lower()}%")
    ).order_by(desc(Movie.release_date))

    return query


def query_api_movie_details(movie_id):
    response = requests.get(
        f"https://api.themoviedb.org/3/movie/{movie_id}?language=en-US",
        headers={
            "accept": "application/json",
            "Authorization": f"Bearer {access_token}",
        },
        timeout=15,
    )
    movie_details = response.json()
    logging.info("Retrieved movie details...")
    return movie_details


def query_api_credits(movie_id):
    """Return cast credit list of a given movie."""

    response = requests.get(
        f"https://api.themoviedb.org/3/movie/{movie_id}/credits?api_key={key}&language=en-US",
        timeout=15,
    )
    movie_credits = response.json()
    logging.info("Retrieved credits...\n")

    return movie_credits["cast"]


def query_api_people(credit_list):
    """Create cast members for given list of credits."""

    update_count = 0
    add_count = 0
    for person in credit_list:
        if isinstance(person, dict):
            person_query = CastMember.query.filter(
                CastMember.id == person["id"]
            ).first()
        else:
            person_query = CastMember.query.filter(
                CastMember.id == person.cast_member.id
            ).first()

        if person_query is None:
            logging.info(
                "%s doesn't exist in database... making api call...", person["name"]
            )
            response = requests.get(
                str.format(
                    "https://api.themoviedb.org/3/person/{}?api_key={}",
                    person["id"],
                    key,
                ),
                timeout=15,
            )
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
        logging.info("Added %s cast to db!", add_count)
    if update_count > 0:
        logging.info("Updated %s cast in db!", update_count)


# if __name__ == "__main__":
#     from app import app

#     connect_to_db(app)
