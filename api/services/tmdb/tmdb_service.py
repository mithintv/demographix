import os
from typing import TypedDict

import requests

from api.services.tmdb.tmdb_dto import (
    TmdbFindResponse,
    TmdbGenreList,
    TmdbMovieDetails,
    TmdbSearchResponse,
)

TMDB_API_KEY = os.environ["TMDB_API_KEY"]
TMDB_ACCESS_TOKEN = os.environ["TMDB_ACCESS_TOKEN"]
TMDB_HOSTNAME = "https://api.themoviedb.org"
TMDB_HEADERS = {
    "accept": "application/json",
    "Authorization": f"Bearer {TMDB_ACCESS_TOKEN}",
}


def find_tmdb_movie_by_imdb_id(imdb_id: str):
    """Find a movie by IMDB ID via TMDB /find endpoint."""
    url = f"{TMDB_HOSTNAME}/3/find/{imdb_id}"
    response = requests.get(
        url,
        headers=TMDB_HEADERS,
        params={"language": "en-US", "external_source": "imdb_id"},
    )
    return TmdbFindResponse(response.json())


def get_tmdb_movie_by_id(movie_id: int):
    """Get movie details by movie_id via TMDB /movie endpoint."""
    url = f"{TMDB_HOSTNAME}/3/movie/{movie_id}"
    response = requests.get(url, headers=TMDB_HEADERS, params={"language": "en-US"})
    return TmdbMovieDetails(response.json())


def search_tmdb_by_title(title: str, year: int, page: int = 1):
    """Search movie by title via TMDB /search endpoint"""
    url = f"{TMDB_HOSTNAME}/3/search/movie"
    response = requests.get(
        url,
        headers=TMDB_HEADERS,
        params={
            "language": "en-US",
            "query": title,
            "primary_release_year": year,
            "page": page,
        },
    )
    return TmdbSearchResponse(response.json())


def get_tmdb_genres():
    """Get genres via TMDB /genre/movie/list endpoint."""
    url = f"{TMDB_HOSTNAME}/3/genre/movie/list"
    response = requests.get(url, headers=TMDB_HEADERS, params={"language": "en-US"})
    return TmdbGenreList(response.json())
