from api.data.model import db
from api.data.movies.movie_repository import get_movie_and_cast_details_by_movie_id
from api.data.nominations.nomination_repository import (
    get_movie_nominations_by_nomination_id,
    get_nomination_by_name_and_year,
)


def get_movie_cast_demographics_by_nomination(event: str, year: int):
    """Return cast demographics for all movies in a given nomination year. Returns an empty list if nomination event and year combination does not exist."""

    nomination = get_nomination_by_name_and_year(event.replace("-", " ").lower(), year)
    if nomination is None:
        return []
    movie_nominations = get_movie_nominations_by_nomination_id(nomination.id)
    movie_cast_demographics = []
    for movie_nomination in movie_nominations:
        movie_data = get_movie_and_cast_details_by_movie_id(movie_nomination.movie_id)
        movie_cast_demographics.append(movie_data)

    return movie_cast_demographics
