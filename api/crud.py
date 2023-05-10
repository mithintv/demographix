"""CRUD operations."""

from model import db, Movie, Credit, CastMember, Gender, connect_to_db


def get_movies():
    """Return all movies."""

    return Movie.query.all()


def get_movie_credits():
    """Return movies with credits."""

    return db.session.query(Movie,
                            Credit).join(Credit).all()


def get_movie_cast(movie_id):
    """Return movies with credits."""

    return db.session.query(CastMember.name, CastMember.birthday, Credit.character, Credit.order).join(Credit).join(Movie).filter(Movie.movie_id == movie_id).all()


if __name__ == '__main__':
    from server import app
    connect_to_db(app)
