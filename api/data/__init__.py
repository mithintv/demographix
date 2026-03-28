# Import all models here to ensure SQLAlchemy mapper configuration
# resolves all relationships at startup.
from api.data.alt_country.alt_country_model import AltCountry  # noqa: F401
from api.data.alt_ethnicities.alt_ethnicity_model import AltEthnicity  # noqa: F401
from api.data.base import db  # noqa: F401
from api.data.cast_ethnicities.cast_ethnicity_model import CastEthnicity  # noqa: F401
from api.data.cast_ethnicity_source_links.cast_ethnicity_source_link_model import (
    CastEthnicitySourceLink,  # noqa: F401
)
from api.data.cast_members.also_known_as_model import AlsoKnownAs  # noqa: F401
from api.data.cast_members.cast_member_model import CastMember  # noqa: F401
from api.data.countries.country_model import Country  # noqa: F401
from api.data.credits.credit_model import Credit  # noqa: F401
from api.data.ethnicities.ethnicity_model import Ethnicity  # noqa: F401
from api.data.genders.gender_model import Gender  # noqa: F401
from api.data.genres.genre_model import Genre  # noqa: F401
from api.data.media_genres.media_genre_model import MediaGenre  # noqa: F401
from api.data.movies.movie_model import Movie  # noqa: F401
from api.data.nominations.nomination_model import (  # noqa: F401
    MovieNomination,
    Nomination,
)
from api.data.races.race_model import CastRace, Race  # noqa: F401
from api.data.regions.region_model import Region  # noqa: F401
from api.data.source_links.source_link_model import SourceLink  # noqa: F401
from api.data.sources.source_model import Source  # noqa: F401
from api.data.sub_regions.sub_region_model import SubRegion  # noqa: F401
