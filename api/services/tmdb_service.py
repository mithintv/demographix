import os
from typing import TypedDict

import requests

TMDB_API_KEY = os.environ["TMDB_API_KEY"]
TMDB_ACCESS_TOKEN = os.environ["TMDB_ACCESS_TOKEN"]
TMDB_HOSTNAME = "https://api.themoviedb.org"
TMDB_HEADERS = {
    "accept": "application/json",
    "Authorization": f"Bearer {TMDB_ACCESS_TOKEN}",
}


class TmdbGenre(TypedDict):
    id: int
    name: str


class TmdbProductionCompany(TypedDict):
    id: int
    logo_path: str
    name: str
    origin_country: str


class TmdbProductionCountry(TypedDict):
    iso_3166_1: str
    name: str


class TmdbSpokenLanguage(TypedDict):
    english_name: str
    iso_639_1: str
    name: str


class TmdbMovieDetails(TypedDict):
    adult: bool
    backdrop_path: str
    belongs_to_collection: str
    budget: int
    genres: list[TmdbGenre]
    homepage: str
    id: int
    imdb_id: str
    origin_country: list[str]
    original_language: str
    original_title: str
    overview: str
    popularity: float
    poster_path: str
    production_companies: list[TmdbProductionCompany]
    production_countries: list[TmdbProductionCountry]
    release_date: str
    revenue: int
    runtime: int
    spoken_languages: list[TmdbSpokenLanguage]
    status: str
    tagline: str
    title: str
    video: bool
    vote_average: float
    vote_count: int


class TmdbMovie(TypedDict):
    adult: bool
    backdrop_path: str
    id: int
    original_language: str
    original_title: str
    overview: str
    popularity: float
    poster_path: str
    release_date: str
    title: str
    video: bool
    vote_average: float
    vote_count: int
    genre_ids: list[int]


class TmdbSearchResponse(TypedDict):
    page: int
    results: list[TmdbMovie]
    total_pages: int
    total_results: int


def get_tmdb_movie_by_id(movie_id: int):
    """Get movie details from TMDB via a movie_id."""
    url = f"{TMDB_HOSTNAME}/3/movie/{movie_id}"
    response = requests.get(url, headers=TMDB_HEADERS, params={"language": "en-US"})
    return TmdbMovieDetails(response.json())


def search_tmdb_by_title(title: str, year: int, page: int = 1) -> TmdbSearchResponse:
    """Search TMBD by movie title"""
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
