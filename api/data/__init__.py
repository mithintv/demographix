# Import all models here to ensure SQLAlchemy mapper configuration
# resolves all relationships at startup.
from api.data.credits.credit_model import Credit  # noqa: F401
from api.data.genres.genre_model import Genre  # noqa: F401
from api.data.base import db  # noqa: F401
from api.data.movies.movie_model import Movie  # noqa: F401
from api.data.nominations.nomination_model import MovieNomination, Nomination  # noqa: F401
