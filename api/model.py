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

    genre = db.relationship("Genre", back_populates="movie")
    credits = db.relationship("Credit", back_populates="movie")

    def __repr__(self):
        return f'<Movie id={self.movie_id} title={self.title}>'


class Genre(db.Model):
    """A genre."""

    __tablename__ = 'genre'

    genre_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(15))
    movie_id = db.Column(db.Integer, db.ForeignKey("movies.movie_id"))

    movie = db.relationship("Movie", back_populates="genre")

    def __repr__(self):
        return f'<Genre genre_id={self.genre_id} name={self.name}>'


class Credit(db.Model):
    """A credit."""

    __tablename__ = 'credits'

    credit_id = db.Column(db.String(), primary_key=True)
    movie_id = db.Column(db.Integer, db.ForeignKey('movies.movie_id'))
    character = db.Column(db.String(50))
    order = db.Column(db.Integer)
    cast_id = db.Column(db.Integer, db.ForeignKey('cast.cast_id'))

    movie = db.relationship("Movie", back_populates="credits")

    def __repr__(self):
        return f'<Credit credit_id={self.credit_id} character={self.character}>'


class Cast(db.Model):
    """A cast member."""

    __tablename__ = 'cast'

    cast_id = db.Column(db.Integer, primary_key=True)
    imdb_id = db.Column(db.String(15))
    name = db.Column(db.String(50))
    original_name = db.Column(db.String(50))
    birthday = db.Column(db.DateTime)
    deathday = db.Column(db.DateTime)
    biography = db.Column(db.String())

    gender = db.relationship("Gender", back_populates="cast")
    ethnicity = db.relationship("Ethnicity", back_populates="cast")
    nationality = db.relationship("Nationality", back_populates="cast")

    def __repr__(self):
        return f'<Cast cast_id={self.cast_id} name={self.name}>'


class Gender(db.Model):
    """A gender."""

    __tablename__ = 'gender'

    gender_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(20))
    cast_id = db.Column(db.Integer, db.ForeignKey('cast.cast_id'))

    cast = db.relationship("Cast", back_populates="gender")


class Ethnicity(db.Model):
    """An ethnicity."""

    __tablename__ = 'ethnicity'

    ethnicity_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(25))
    cast_id = db.Column(db.Integer, db.ForeignKey('cast.cast_id'))

    cast = db.relationship("Cast", back_populates="ethnicity")


class Nationality(db.Model):
    """A nationality."""

    __tablename__ = 'nationality'

    nationality_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(75))
    cast_id = db.Column(db.Integer, db.ForeignKey('cast.cast_id'))

    cast = db.relationship("Cast", back_populates="nationality")

    def __repr__(self):
        return f'<Credit credit_id={self.credit_id} movie_id={self.movie_id} character={self.character}>'


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
