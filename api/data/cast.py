import logging

from sqlalchemy import func

from api.model import CastMember, Country, Credit, Gender, Movie


def query_cast(keywords):
    """Return search query results for a cast member."""

    query = CastMember.query.filter(
        func.lower(CastMember.name).like(f"%{keywords.lower()}%")
    ).all()
    return query


def get_movie_cast(movie_id):
    """Return specific movie with credits and cast member details."""

    movie = Movie.query.filter(Movie.id == movie_id).first()
    if movie is None:
        logging.warning("Movie details are missing for %s", movie_id)
        return {}
        # logging.info("Movie details are missing...\nMaking api call...\n")

        # # Update movie
        # movie_details = query_api_movie_details(movie_id)
        # update_movie_with_movie_details(movie, movie_details)

        # # Get cast list and add cast members
        # cast_credit_list = query_api_credits(movie_id)
        # query_api_people(cast_credit_list)

        # # Add credits after adding cast members
        # add_credits(cast_credit_list, movie)

    logging.info("Fetching details about %s...", movie.title)

    cast_list = (
        CastMember.query.join(
            Credit, Credit.cast_member_id == CastMember.id, isouter=True
        )
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
        races = [race.name for race in cast.races]
        ethnicities = []
        for cast_ethnicity in cast.ethnicities:
            ethnicities.append(
                {
                    "name": cast_ethnicity.ethnicity.name,
                    "sources": [source.link for source in cast_ethnicity.sources],
                }
            )

        new_cast = {
            "id": cast.id,
            "name": cast.name,
            "birthday": cast.birthday,
            "gender": cast.gender.name,
            "ethnicity": ethnicities,
            "race": races,
            "country_of_birth": cast.country_of_birth.id
            if cast.country_of_birth
            else None,
            "character": cast.credits[0].character,
            "order": cast.credits[0].order,
            "profile_path": cast.profile_path,
        }
        cast_details.append(new_cast)

    genre_list = [genre.name for genre in movie.genres]

    movie_dict = movie.to_dict()
    movie_dict["genres"] = genre_list
    movie_dict["cast"] = cast_details

    return movie_dict
