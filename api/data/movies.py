import logging
import os

key = os.environ["TMDB_API_KEY"]
access_token = os.environ["TMDB_ACCESS_TOKEN"]


def update_movie_with_movie_details(movie, movie_details):
    """Update movie from api call for movie details."""

    movie.imdb_id = movie_details["imdb_id"]
    movie.runtime = movie_details["runtime"]
    movie.budget = movie_details["budget"]
    movie.revenue = movie_details["revenue"]

    logging.info("Updated existing movie: %s", movie.title)


# movie_ids = credits.get_movie_ids()

# movie_details_list = []
# for movie_id in movie_ids:
#     movie_details = get_movie_details(movie_id)
#     movie_details_list.append(movie_details)

# with open('movie_details.json', 'w') as file:
#     json.dump(movie_details_list, file)
