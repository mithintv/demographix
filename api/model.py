"""Models for movie ratings app."""

from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


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
        "Genre", secondary="media_genres", back_populates="movies")
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
    """An association table for different mediums and their genres."""

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
    movie_id = db.Column(db.Integer, db.ForeignKey('movies.movie_id'))
    character = db.Column(db.String(50))
    order = db.Column(db.Integer)
    cast_member_id = db.Column(
        db.Integer, db.ForeignKey('cast_members.cast_member_id'))

    movie = db.relationship("Movie", back_populates="credits")

    def __repr__(self):
        return f'<Credit credit_id={self.credit_id} character={self.character}>'


class CastMember(db.Model):
    """A cast member."""

    __tablename__ = 'cast_members'

    cast_member_id = db.Column(db.Integer, primary_key=True)
    imdb_id = db.Column(db.String(15))
    name = db.Column(db.String(50))
    birthday = db.Column(db.DateTime)
    deathday = db.Column(db.DateTime)
    biography = db.Column(db.String())

    genders = db.relationship(
        "Gender", secondary="cast_genders", back_populates="cast_member")
    # ethnicities = db.relationship("Ethnicity", back_populates="cast")
    # nationalities = db.relationship("Nationality", back_populates="cast")

    def __repr__(self):
        return f'<Cast cast_member_id={self.cast_member_id} name={self.name}>'


class Gender(db.Model):
    """A gender."""

    __tablename__ = 'genders'

    gender_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(20))

    cast_member = db.relationship(
        "CastMember", secondary="cast_genders", back_populates="genders")

    def __repr__(self):
        return f'<Gender gender_id={self.gender_id} name={self.name}>'


class CastGender(db.Model):
    """An association table for cast and their genders."""

    __tablename__ = 'cast_genders'

    cast_gender_id = db.Column(
        db.Integer, primary_key=True, autoincrement=True)
    gender_id = db.Column(db.Integer, db.ForeignKey('genders.gender_id'))
    cast_member_id = db.Column(
        db.Integer, db.ForeignKey('cast_members.cast_member_id'))

    def __repr__(self):
        return f'<CastGender cast_gender_id={self.cast_gender_id} gender_id={self.gender_id} cast_member_id={self.cast_member_id}>'


# class Ethnicity(db.Model):
#     """An ethnicity."""

#     __tablename__ = 'ethnicity'

#     ethnicity_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
#     name = db.Column(db.String(25))
#     cast_id = db.Column(db.Integer, db.ForeignKey('cast.cast_id'))

#     cast = db.relationship("Cast", back_populates="ethnicity")


# class Nationality(db.Model):
#     """A nationality."""

#     __tablename__ = 'nationality'

#     nationality_id = db.Column(db.Integer, primary_key=True)
#     name = db.Column(db.String(75))
#     cast_id = db.Column(db.Integer, db.ForeignKey('cast.cast_id'))

#     cast = db.relationship("Cast", back_populates="nationality")

#     def __repr__(self):
#         return f'<Credit credit_id={self.credit_id} movie_id={self.movie_id} character={self.character}>'


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
