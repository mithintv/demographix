import logging

from data.model import (
    AltEthnicity,
    CastEthnicity,
    CastMember,
    Country,
    Credit,
    Ethnicity,
    Gender,
    Movie,
    Race,
    Source,
    SourceLink,
    db,
)
from services.ethnicity import get_ethnicity
from sqlalchemy import and_, func


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
            "country_of_birth": (
                cast.country_of_birth.id if cast.country_of_birth else None
            ),
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
            "Added new ref link: %s for %s ethnicity for %s",
            new_source_link.link,
            ethnicity_object.name,
            new_person.name,
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

    existing_races = set()
    for races in new_person.races:
        existing_races.add(races.id)

    add_race_ids = set()
    for cast_ethnicity in new_person.ethnicities:
        # If region is specified in ethnicity, set approx_country to that ethnicity which has region and subregion attributes.
        # Otherwise, query a country object which also has region and subregion attributes
        if cast_ethnicity.ethnicity.region is not None:
            approx_country = cast_ethnicity.ethnicity
        else:
            approx_country = Country.query.filter(
                Country.demonym == cast_ethnicity.ethnicity.name
            ).first()

        if approx_country is not None:
            logging.info(
                "%s is approximately in %s, %s, %s",
                cast_ethnicity.ethnicity.name,
                approx_country.name,
                approx_country.subregion.name,
                approx_country.region.name,
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

                if approx_country.region.name == "Africa" or approx_country.name in [
                    "Haiti",
                    "Dominican Republic",
                    "Trinidad and Tobago",
                ]:
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
                "Could not associate %s with a country", cast_ethnicity.ethnicity.name
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


def update_cast_member(person_obj, person_order):
    curr_person = CastMember.query.filter(CastMember.id == person_obj.id).first()
    if curr_person is not None and person_order < 10:
        # Add/Update ethnicity data
        add_ethnicity_data(curr_person)

        # Add race data
        add_race_data(curr_person)
