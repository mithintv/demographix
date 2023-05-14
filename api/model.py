"""Models for movie ratings app."""

from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


class Country(db.Model):
    """A country."""

    __tablename__ = 'countries'

    country_id = db.Column(db.String(3), primary_key=True)
    name = db.Column(db.String(75))
    demonym = db.Column(db.String(75))
    region = db.Column(db.String(15))

    alt_names = db.relationship("AltCountry", back_populates="country")
    births = db.relationship(
        "CastMember", back_populates="country_of_birth")

    def __repr__(self):
        return f'<Country country_id={self.country_id} name={self.name} demonym={self.demonym}>'


class AltCountry(db.Model):
    """An association table for alternate ways to denote a country."""

    __tablename__ = 'alt_countries'

    alt_country_id = db.Column(
        db.Integer, autoincrement=True, primary_key=True)
    country_id = db.Column(db.String(3), db.ForeignKey("countries.country_id"))
    alt_name = db.Column(db.String(75))

    country = db.relationship("Country", uselist=False,
                              back_populates="alt_names")

    def __repr__(self):
        return f'<AltCountry alt_country_id={self.alt_country_id} country_id={self.country_id}> alt_name={self.alt_name}'


class Movie(db.Model):
    """A movie."""

    __tablename__ = 'movies'

    movie_id = db.Column(db.Integer, primary_key=True)
    imdb_id = db.Column(db.String(15))
    title = db.Column(db.String(255))
    overview = db.Column(db.String())
    runtime = db.Column(db.Integer)
    poster_path = db.Column(db.String())
    release_date = db.Column(db.DateTime)
    budget = db.Column(db.Integer)
    revenue = db.Column(db.Integer)

    genres = db.relationship(
        "Genre", secondary="media_genres", uselist=True, back_populates="movies")
    credits = db.relationship("Credit", back_populates="movie")

    def __repr__(self):
        return f'<Movie id={self.movie_id} title={self.title}>'


class Genre(db.Model):
    """A genre."""

    __tablename__ = 'genres'

    genre_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(15))

    movies = db.relationship(
        "Movie", secondary="media_genres", back_populates="genres")

    def __repr__(self):
        return f'<Genre genre_id={self.genre_id} name={self.name}>'


class MediaGenre(db.Model):
    """An association table for different media and their genres."""

    __tablename__ = 'media_genres'

    media_genre_id = db.Column(
        db.Integer, primary_key=True, autoincrement=True)
    genre_id = db.Column(db.Integer, db.ForeignKey("genres.genre_id"))
    movie_id = db.Column(db.Integer, db.ForeignKey("movies.movie_id"))

    def __repr__(self):
        return f'<MediaGenre genre_id={self.genre_id} movie_id={self.movie_id}>'


class Credit(db.Model):
    """A credit."""

    __tablename__ = 'credits'

    credit_id = db.Column(db.String(), primary_key=True)
    movie_id = db.Column(db.Integer, db.ForeignKey(
        'movies.movie_id'), nullable=False)
    character = db.Column(db.String(50))
    order = db.Column(db.Integer)
    cast_member_id = db.Column(
        db.Integer, db.ForeignKey('cast_members.cast_member_id'), nullable=False)

    movie = db.relationship("Movie", uselist=False, back_populates="credits")
    cast_member = db.relationship(
        "CastMember", uselist=False, back_populates="credits")

    def __repr__(self):
        return f'<Credit credit_id={self.credit_id} character={self.character}>'


class CastMember(db.Model):
    """A cast member."""

    __tablename__ = 'cast_members'

    cast_member_id = db.Column(db.Integer, primary_key=True)
    imdb_id = db.Column(db.String(15))
    name = db.Column(db.String(50), nullable=False)
    gender_id = db.Column(
        db.Integer, db.ForeignKey("genders.gender_id"), nullable=False)
    birthday = db.Column(db.DateTime)
    deathday = db.Column(db.DateTime)
    biography = db.Column(db.String())
    country_of_birth_id = db.Column(
        db.String(3), db.ForeignKey("countries.country_id"))

    gender = db.relationship(
        "Gender", back_populates="cast_member")
    country_of_birth = db.relationship("Country", back_populates="births")
    credits = db.relationship("Credit", back_populates="cast_member")
    ethnicities = db.relationship(
        "Ethnicity", secondary="cast_ethnicities", uselist=True, back_populates="cast")
    # nationalities = db.relationship("Nationality", back_populates="cast")

    def __repr__(self):
        return f'<Cast cast_member_id={self.cast_member_id} name={self.name}>'


class Gender(db.Model):
    """A gender."""

    __tablename__ = 'genders'

    gender_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(20))

    cast_member = db.relationship(
        "CastMember", back_populates="gender")

    def __repr__(self):
        return f'<Gender gender_id={self.gender_id} name={self.name}>'


class Ethnicity(db.Model):
    """An ethnicity."""

    __tablename__ = 'ethnicities'

    ethnicity_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(75))

    alt_names = db.relationship(
        "AltEthnicity", back_populates="ethnicity")
    cast = db.relationship(
        "CastMember", secondary="cast_ethnicities", back_populates="ethnicities")

    def __repr__(self):
        return f'<Ethnicity ethnicity_id={self.ethnicity_id} name={self.name}>'


class AltEthnicity(db.Model):
    """An alternate name for an ethnicity."""

    __tablename__ = 'alt_ethnicities'

    alt_ethnicity_id = db.Column(
        db.Integer, primary_key=True, autoincrement=True)
    ethnicity_id = db.Column(
        db.Integer, db.ForeignKey("ethnicities.ethnicity_id"))
    alt_name = db.Column(db.String(75))

    ethnicity = db.relationship(
        "Ethnicity", uselist=False, back_populates="alt_names")

    def __repr__(self):
        return f'<AltEthnicity ethnicity_id={self.ethnicity_id} name={self.alt_name}>'


class CastEthnicity(db.Model):
    """An association table to link cast members and their ethnicities."""

    __tablename__ = 'cast_ethnicities'

    cast_ethnicity_id = db.Column(
        db.Integer, autoincrement=True, primary_key=True)
    ethnicity_id = db.Column(
        db.Integer, db.ForeignKey("ethnicities.ethnicity_id"))
    cast_member_id = db.Column(
        db.Integer, db.ForeignKey("cast_members.cast_member_id"))

    def __repr__(self):
        return f'<CastEthnicity cast_ethnicity_id={self.cast_ethnicity_id} ethnicity_id={self.ethnicity_id} cast_member_id={self.cast_member_id}>'


def connect_to_db(flask_app, db_uri="postgresql:///demographix", echo=False):
    flask_app.config["SQLALCHEMY_DATABASE_URI"] = db_uri
    flask_app.config["SQLALCHEMY_ECHO"] = echo
    flask_app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    db.app = flask_app
    db.init_app(flask_app)

    print("Connected to the db!")


if __name__ == "__main__":
    from server import app
    connect_to_db(app)
