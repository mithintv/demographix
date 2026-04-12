from api.data.movies.movie_repository import find_movie_and_details_by_id
from api.data.nominations.nomination_repository import (
    get_movie_nominations_by_nomination_id,
    get_nominations_by_imdb_event_id_and_award_year,
)


def get_movie_cast_demographics_by_nomination(event: str, year: int):
    """Return cast demographics for all movies in a given nomination year. Returns an empty list if nomination event and year combination does not exist."""

    nominations = get_nominations_by_imdb_event_id_and_award_year(event.lower(), year)

    movie_nominations = set()
    for nomination in nominations:
        award_nomination = get_movie_nominations_by_nomination_id(nomination.id)
        movie_nominations.add(award_nomination)
    movie_cast_demographics = []
    for movie_nomination in movie_nominations:
        movie_data = find_movie_and_details_by_id(movie_nomination.movie_id)
        movie_cast_demographics.append(movie_data)

    return movie_cast_demographics
