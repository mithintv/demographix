from api.data.movies.movie_repository import find_movie_and_details_by_id
from api.data.nominations.nomination_repository import (
    get_movie_nominations_by_nomination_id,
    get_nominations_by_event_id_and_award_year,
)


def get_movie_cast_demographics_by_nomination(event_id: int, year: int):
    """Return cast demographics for all movies in a given nomination year. Returns an empty list if nomination event and year combination does not exist."""

    nominations = get_nominations_by_event_id_and_award_year(event_id, year)

    seen_movie_ids = set()
    movie_cast_demographics = []
    for nomination in nominations:
        for movie_nomination in get_movie_nominations_by_nomination_id(nomination.id):
            if movie_nomination.movie_id not in seen_movie_ids:
                seen_movie_ids.add(movie_nomination.movie_id)
                movie_data = find_movie_and_details_by_id(movie_nomination.movie_id)
                movie_cast_demographics.append(movie_data)

    return movie_cast_demographics
