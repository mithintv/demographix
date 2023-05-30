"""Models for movie ratings app."""

from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


class Region(db.Model):
    """A region."""

    __tablename__ = 'regions'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(15))

    subregions = db.relationship(
        "SubRegion", back_populates="region")
    countries = db.relationship("Country", back_populates="region")
    ethnicities = db.relationship("Ethnicity", back_populates="region")

    def __repr__(self):
        return f'<Region id={self.id} name={self.name}>'


class SubRegion(db.Model):
    """A subregion."""

    __tablename__ = 'subregions'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(25))
    region_id = db.Column(db.Integer, db.ForeignKey("regions.id"))

    region = db.relationship(
        "Region", back_populates="subregions")
    countries = db.relationship("Country", back_populates="subregion")
    ethnicities = db.relationship("Ethnicity", back_populates="subregion")

    def __repr__(self):
        return f'<SubRegion id={self.id} name={self.name}>'


class Country(db.Model):
    """A country."""

    __tablename__ = 'countries'

    id = db.Column(db.String(3), primary_key=True)
    name = db.Column(db.String(75), nullable=False)
    demonym = db.Column(db.String(75))
    region_id = db.Column(db.Integer, db.ForeignKey(
        "regions.id"), nullable=False)
    subregion_id = db.Column(db.Integer, db.ForeignKey(
        "subregions.id"), nullable=False)

    alt_names = db.relationship("AltCountry", back_populates="country")
    region = db.relationship("Region", back_populates="countries")
    subregion = db.relationship("SubRegion", back_populates="countries")
    births = db.relationship(
        "CastMember", back_populates="country_of_birth")

    def __repr__(self):
        return f'<Country id={self.id} name={self.name} demonym={self.demonym}>'


class AltCountry(db.Model):
    """An association table for alternate ways to denote a country."""

    __tablename__ = 'alt_countries'

    id = db.Column(
        db.Integer, primary_key=True)
    country_id = db.Column(db.String(3), db.ForeignKey("countries.id"))
    alt_name = db.Column(db.String(75))

    country = db.relationship("Country", uselist=False,
                              back_populates="alt_names")

    def __repr__(self):
        return f'<AltCountry id={self.id} country_id={self.country_id}> alt_name={self.alt_name}'


class Movie(db.Model):
    """A movie."""

    __tablename__ = 'movies'

    id = db.Column(db.Integer, primary_key=True)
    imdb_id = db.Column(db.String(15))
    title = db.Column(db.String(255))
    overview = db.Column(db.String())
    runtime = db.Column(db.Integer)
    poster_path = db.Column(db.String())
    release_date = db.Column(db.DateTime)
    budget = db.Column(db.BigInteger)
    revenue = db.Column(db.BigInteger)

    genres = db.relationship(
        "Genre", secondary="media_genres", uselist=True, back_populates="movies")
    credits = db.relationship("Credit", back_populates="movie")
    nominations = db.relationship("Nomination", secondary="movie_nominations", back_populates="movies")

    def __repr__(self):
        return f'<Movie id={self.id} title={self.title}>'


class Nomination(db.Model):
    """A nomination."""

    __tablename__ = 'nominations'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(25))
    year = db.Column(db.Integer)

    movies = db.relationship("Movie", secondary="movie_nominations", back_populates="nominations")

    def __repr__(self):
        return f'<Nomination id={self.id} name={self.name} year={self.year}>'


class MovieNomination(db.Model):
    """An association table for movies and their respective nominations."""

    __tablename__ = 'movie_nominations'

    id = db.Column(db.Integer, primary_key=True)
    movie_id = db.Column(db.Integer, db.ForeignKey("movies.id"))
    nomination_id = db.Column(db.Integer, db.ForeignKey("nominations.id"))

    def __repr__(self):
        return f'<MovieNomination id={self.id} movie_id={self.movie_id} nomination_id={self.nomination_id}>'


class Genre(db.Model):
    """A genre."""

    __tablename__ = 'genres'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(15))

    movies = db.relationship(
        "Movie", secondary="media_genres", back_populates="genres")

    def __repr__(self):
        return f'<Genre id={self.id} name={self.name}>'


class MediaGenre(db.Model):
    """An association table for different media and their genres."""

    __tablename__ = 'media_genres'

    id = db.Column(
        db.Integer, primary_key=True)
    genre_id = db.Column(db.Integer, db.ForeignKey("genres.id"))
    movie_id = db.Column(db.Integer, db.ForeignKey("movies.id"))

    def __repr__(self):
        return f'<MediaGenre genre_id={self.genre_id} movie_id={self.movie_id}>'


class Credit(db.Model):
    """A credit."""

    __tablename__ = 'credits'

    id = db.Column(db.String(), primary_key=True)
    movie_id = db.Column(db.Integer, db.ForeignKey(
        'movies.id'), nullable=False)
    character = db.Column(db.String(50))
    order = db.Column(db.Integer)
    cast_member_id = db.Column(
        db.Integer, db.ForeignKey('cast_members.id'), nullable=False)

    movie = db.relationship("Movie", uselist=False, back_populates="credits")
    cast_member = db.relationship(
        "CastMember", uselist=False, back_populates="credits")

    def __repr__(self):
        return f'<Credit id={self.id} character={self.character}>'


class CastMember(db.Model):
    """A cast member."""

    __tablename__ = 'cast_members'

    id = db.Column(db.Integer, primary_key=True)
    imdb_id = db.Column(db.String(15))
    name = db.Column(db.String(50), nullable=False)
    gender_id = db.Column(
        db.Integer, db.ForeignKey("genders.id"), nullable=False)
    birthday = db.Column(db.DateTime)
    deathday = db.Column(db.DateTime)
    biography = db.Column(db.String())
    country_of_birth_id = db.Column(
        db.String(3), db.ForeignKey("countries.id"))
    profile_path = db.Column(db.String(35))

    also_known_as = db.relationship(
        "AlsoKnownAs", uselist=True, back_populates="cast_member")
    gender = db.relationship(
        "Gender", back_populates="cast_member")
    country_of_birth = db.relationship("Country", back_populates="births")
    credits = db.relationship("Credit", back_populates="cast_member")
    ethnicities = db.relationship(
        "CastEthnicity", uselist=True, back_populates="cast_member")
    races = db.relationship(
        "Race", secondary="cast_races", uselist=True, back_populates="cast")
    # nationalities = db.relationship("Nationality", back_populates="cast")

    def __repr__(self):
        return f'<Cast id={self.id} name={self.name}>'


class AlsoKnownAs(db.Model):
    """Alternative names for cast members."""

    __tablename__ = 'also_known_as'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(), nullable=False)
    cast_member_id = db.Column(db.Integer, db.ForeignKey("cast_members.id"))

    cast_member = db.relationship("CastMember", back_populates="also_known_as")

    def __repr__(self):
        return f'<AlsoKnownAs id={self.id} name={self.name} cast_member_id={self.cast_member_id}>'


class Gender(db.Model):
    """A gender."""

    __tablename__ = 'genders'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(20))

    cast_member = db.relationship(
        "CastMember", back_populates="gender")

    def __repr__(self):
        return f'<Gender id={self.id} name={self.name}>'


class Ethnicity(db.Model):
    """An ethnicity."""

    __tablename__ = 'ethnicities'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(75), nullable=False)
    region_id = db.Column(db.Integer, db.ForeignKey("regions.id"))
    subregion_id = db.Column(db.Integer, db.ForeignKey("subregions.id"))

    alt_names = db.relationship(
        "AltEthnicity", back_populates="ethnicity")
    region = db.relationship("Region", back_populates="ethnicities")
    subregion = db.relationship("SubRegion", back_populates="ethnicities")
    cast_ethnicity = db.relationship("CastEthnicity", back_populates="ethnicity")

    def __repr__(self):
        return f'<Ethnicity id={self.id} name={self.name}>'


class AltEthnicity(db.Model):
    """An alternate name for an ethnicity."""

    __tablename__ = 'alt_ethnicities'

    id = db.Column(
        db.Integer, primary_key=True)
    ethnicity_id = db.Column(
        db.Integer, db.ForeignKey("ethnicities.id"), nullable=False)
    alt_name = db.Column(db.String(75))

    ethnicity = db.relationship(
        "Ethnicity", uselist=False, back_populates="alt_names")

    def __repr__(self):
        return f'<AltEthnicity ethnicity_id={self.ethnicity_id} alt_name={self.alt_name}>'


class CastEthnicity(db.Model):
    """An association table to link cast members and their ethnicities."""

    __tablename__ = 'cast_ethnicities'

    id = db.Column(
        db.Integer, primary_key=True)
    ethnicity_id = db.Column(
        db.Integer, db.ForeignKey("ethnicities.id"))
    cast_member_id = db.Column(
        db.Integer, db.ForeignKey("cast_members.id"))

    cast_member = db.relationship("CastMember", back_populates='ethnicities')
    ethnicity = db.relationship("Ethnicity", back_populates='cast_ethnicity')
    sources = db.relationship("SourceLink", secondary="cast_ethnicity_source_links", back_populates="cast_ethnicities")

    def __repr__(self):
        return f'<CastEthnicity ethnicity_id={self.ethnicity_id} cast_member_id={self.cast_member_id}>'


class Race(db.Model):
    """A race according to the US Census."""

    __tablename__ = 'races'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(75))
    short = db.Column(db.String(5), unique=True)
    description = db.Column(db.String())

    cast = db.relationship(
        "CastMember", secondary="cast_races", back_populates="races")

    def __repr__(self):
        return f'<Race race_id={self.id} name={self.name} short={self.short}>'


class CastRace(db.Model):
    """An association table to link cast members with their respective races."""

    __tablename__ = 'cast_races'

    id = db.Column(db.Integer, primary_key=True)
    race_id = db.Column(db.Integer, db.ForeignKey("races.id"))
    cast_member_id = db.Column(db.Integer, db.ForeignKey("cast_members.id"))

    def __repr__(self):
        return f'<CastRace race_id={self.race_id} cast_id={self.cast_member_id}>'


class Source(db.Model):
    """A table listing demographic data sources."""

    __tablename__ = 'sources'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(25))
    domain = db.Column(db.String())

    links = db.relationship("SourceLink", uselist=True, back_populates="source")

    def __repr__(self):
        return f'<Source id={self.id} name={self.name} domain={self.domain}>'


class SourceLink(db.Model):
    """An association table for demographic data sources and the data they are providing."""

    __tablename__ = 'source_links'

    id = db.Column(db.Integer, primary_key=True)
    source_id = db.Column(db.Integer, db.ForeignKey("sources.id"))
    link = db.Column(db.String())

    source = db.relationship("Source", back_populates="links")
    cast_ethnicities = db.relationship("CastEthnicity", secondary="cast_ethnicity_source_links", back_populates="sources")

    def __repr__(self):
        return f'<SourceLink id={self.id} source_id={self.source_id} link={self.link}>'


class CastEthnicitySourceLink(db.Model):
    """An association table for cast ethnicities and the source links they are retrieved from."""

    __tablename__ = 'cast_ethnicity_source_links'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    source_link_id = db.Column(db.Integer, db.ForeignKey("source_links.id"))
    cast_ethnicity_id = db.Column(db.Integer, db.ForeignKey("cast_ethnicities.id"))

    def __repr__(self):
        return f'<CastEthnicitySourceLink id={self.id} source_link_id={self.source_link_id} link={self.link} cast_ethnicity_id={self.cast_ethnicity_id}>'


def connect_to_db(flask_app, db_uri="postgresql:///demographix", echo=False):
    flask_app.config["SQLALCHEMY_DATABASE_URI"] = db_uri
    flask_app.config["SQLALCHEMY_ECHO"] = echo
    flask_app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    db.app = flask_app
    db.init_app(flask_app)

    print("Connected to the db!")
    return db


if __name__ == "__main__":
    from app import app
    connect_to_db(app)
