from typing import TypedDict


class TmdbGenre(TypedDict):
    id: int
    name: str


class TmdbGenreList(TypedDict):
    genres: list[TmdbGenre]


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


class TmdbFindResponse(TypedDict):
    movie_results: list[TmdbMovie]
    person_results: list
    tv_results: list
    tv_episode_results: list
    tv_season_results: list


class TmdbCredit(TypedDict):
    """Credit entry from TMDB movie credits.

    - `id`: person_id in TMDB.
    - `credit_id`: unique identifier for the credit itself.
    """

    adult: bool
    gender: int
    id: int
    known_for_department: str
    name: str
    original_name: str
    popularity: float
    profile_path: str | None
    cast_id: int
    character: str
    credit_id: str
    order: int


class TmdbMovieCredits(TypedDict):
    id: int
    cast: list[TmdbCredit]


class TmdbPersonDetails(TypedDict):
    adult: bool
    also_known_as: list[str]
    biography: str
    birthday: str
    deathday: str
    gender: int
    homepage: str
    id: int
    imdb_id: str
    known_for_department: str
    name: str
    place_of_birth: str
    popularity: float
    profile_path: str
