"""Script to seed database."""

from pathlib import Path

from sqlalchemy import select

from api.app import app
from api.data.countries.alt_country_model import AltCountry
from api.data.ethnicities.alt_ethnicity_model import AltEthnicity
from api.data.awards.award_model import Award
from api.data.base import db
from api.data.countries.country_model import Country
from api.data.ethnicities.ethnicity_model import Ethnicity
from api.data.events.event_model import Event
from api.data.genders.gender_model import Gender
from api.data.genres.genre_model import Genre
from api.data.races.race_model import Race
from api.data.regions.region_model import Region
from api.data.subregions.subregion_model import SubRegion
from api.data.types import Dto
from api.scripts.seed.countries import countries
from api.scripts.seed.ethnicities import ethnicities
from api.scripts.seed.events import events
from api.scripts.seed.races import races
from api.scripts.seed.subregions import subregions
from api.services.tmdb.tmdb_service import get_tmdb_genres

SEED_DIR = Path(__file__).parent


def seed_regions():
    """Seed regions table with region information."""

    region_list = ["Africa", "Americas", "Antarctic", "Asia", "Europe", "Oceania"]
    regions = []
    for region in region_list:
        new_region = Region(name=region)
        regions.append(new_region)

    db.session.add_all(regions)
    db.session.commit()
    print(f"Added {len(regions)} regions to db!")


def seed_subregions():
    """Seed subregion table with subregion information."""

    new_subregions = []
    for subregion in subregions:
        region = db.session.scalars(
            select(Region).where(Region.name == subregion["region"])
        ).one()
        new_subregion = SubRegion(
            name=subregion["subregion"],
            region_id=region.id,
        )
        new_subregions.append(new_subregion)

    db.session.add_all(new_subregions)
    db.session.commit()
    print(f"Added {len(new_subregions)} subregions to db!")


def seed_countries():
    """Seed countries table with country information."""

    countries_list = []
    for country in countries:
        if country.get("demonyms", None) is None:
            demonym = "Unknown"
        else:
            demonym = country["demonyms"]["eng"]["f"]

        region = db.session.scalars(
            select(Region).where(Region.name == country["region"])
        ).one()
        subregion = db.session.scalars(
            select(SubRegion).where(SubRegion.name == country["subregion"])
        ).one()
        new_country = Country(
            name=country["name"]["common"],
            cca3=country["cca3"],
            demonym=demonym,
            region_id=region.id,
            subregion_id=subregion.id,
        )

        for alt_spelling in country["altSpellings"]:
            new_alt_spelling = AltCountry(
                country_id=new_country.id, alt_name=alt_spelling
            )
            new_country.alt_names.append(new_alt_spelling)

        countries_list.append(new_country)

    db.session.add_all(countries_list)
    db.session.commit()
    print(f"Added {len(countries_list)} countries to db!")


def seed_ethnicities():
    """Seed ethnicities table with ethnicity information."""

    new_ethnicities = []
    for ethnicity in ethnicities:
        if ethnicity not in [
            "Alabama",
            "Alaska",
            "Arizona",
            "Arkansas",
            "California",
            "Colorado",
            "Connecticut",
            "Delaware",
            "District of Columbia",
            "Florida",
            "Georgia",
            "Hawaii",
            "Idaho",
            "Illinois",
            "Indiana",
            "Iowa",
            "Kansas",
            "Kentucky",
            "Louisiana",
            "Maine",
            "Maryland",
            "Massachusetts",
            "Michigan",
            "Minnesota",
            "Mississippi",
            "Missouri",
            "Montana",
            "Nebraska",
            "Nevada",
            "New Hampshire",
            "New Jersey",
            "New Mexico",
            "New York",
            "North Carolina",
            "North Dakota",
            "Ohio",
            "Oklahoma",
            "Oregon",
            "Pennsylvania",
            "Rhode Island",
            "South Carolina",
            "South Dakota",
            "Tennessee",
            "Texas",
            "Utah",
            "Vermont",
            "Virginia",
            "Washington",
            "West Virginia",
            "Wisconsin",
            "Wyoming",
        ]:
            new_ethnicity = None
            if isinstance(ethnicity, dict):
                subregion = db.session.scalars(
                    select(SubRegion).where(SubRegion.name == ethnicity["subregion"])
                ).one_or_none()
                if subregion is not None:
                    new_ethnicity = Ethnicity(
                        name=ethnicity["name"],
                        subregion_id=subregion.id,
                    )
            else:
                if "/" in ethnicity:
                    ethnicity_split = ethnicity.split("/")
                    new_ethnicity = Ethnicity(name=ethnicity_split[0])
                    for alt_ethnicity_name in ethnicity_split[1:]:
                        alt_ethnicity = AltEthnicity(
                            alt_name=alt_ethnicity_name,
                            ethnicity_id=new_ethnicity.id,
                        )
                        new_ethnicity.alt_names.append(alt_ethnicity)
                else:
                    new_ethnicity = Ethnicity(name=ethnicity)
            new_ethnicities.append(new_ethnicity)

    db.session.add_all(new_ethnicities)
    db.session.commit()
    print(f"Added {len(new_ethnicities)} ethnicities to db!")


def seed_races():
    """Seed race table with race information from the US census."""

    new_races = []
    for race in races:
        new_race = Race(
            name=race["name"], short=race["short"], description=race["description"]
        )
        new_races.append(new_race)

    db.session.add_all(new_races)
    db.session.commit()
    print(f"Added {len(new_races)} races to db!")


def seed_genders():
    """Seed genders table in database."""

    gender_list: list[Dto] = [
        {"id": 0, "name": "Unknown"},
        {"id": 1, "name": "Female"},
        {"id": 2, "name": "Male"},
        {"id": 3, "name": "Non-Binary"},
    ]
    genders = []
    for gender in gender_list:
        new_gender = Gender(id=gender["id"], name=gender["name"])
        genders.append(new_gender)

    db.session.add_all(genders)
    db.session.commit()
    print(f"Added {len(genders)} genders to db!")


def seed_genres():
    """Seed genres table in database."""

    tmdb_genres = get_tmdb_genres()
    genres = []
    for genre in tmdb_genres["genres"]:
        new_genre = Genre(id=genre["id"], name=genre["name"])
        genres.append(new_genre)

    db.session.add_all(genres)
    db.session.commit()
    print(f"Added {len(genres)} genres to db!")


def seed_events():
    """Seed events table with event information."""

    new_awards = []
    new_events = []
    for event in events:
        new_event = Event(name=event["name"], imdb_event_id=event["imdb_event_id"])
        new_events.append(new_event)
        db.session.add(new_event)
        db.session.flush()
        for award in event["awards"]:
            new_award = Award(event_id=new_event.id, name=award)
            new_awards.append(new_award)
            db.session.add(new_award)

    db.session.commit()
    print(f"Added {len(new_events)} events to db!")
    print(f"Added {len(new_awards)} awards to db!")


def seed_all():
    """Seed all tables."""
    seed_regions()
    seed_subregions()
    seed_countries()
    seed_ethnicities()
    seed_races()
    seed_genders()
    seed_genres()
    seed_events()


if __name__ == "__main__":
    with app.app_context():
        seed_all()
