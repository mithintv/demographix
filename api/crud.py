"""CRUD operations."""

from model import db, Movie, Credit, CastMember, Gender, CastGender, connect_to_db


def get_movies():
    """Return all movies."""

    return Movie.query.all()


def get_movie_credits():
    """Return movies with credits."""

    return db.session.query(Movie,
                            Credit).join(Credit).all()


def get_movie_cast(movie_id):
    """Return specific movie with credits and cast member details."""

    # return db.session.query(CastMember.name, CastMember.birthday, CastMember.genders, Credit.character, Credit.order).join(Credit).join(Movie).filter(Movie.movie_id == movie_id).all()

    return db.session.query(
        CastMember.name,
        CastMember.birthday,
        Gender.name.label('gender'),
        Credit.character,
        Credit.order
    ).join(CastGender, CastGender.cast_member_id == CastMember.cast_member_id
           ).join(Gender, Gender.gender_id == CastGender.gender_id
                  ).join(Credit, Credit.cast_member_id == CastMember.cast_member_id
                         ).join(Movie, Movie.movie_id == Credit.movie_id
                                ).filter(Movie.movie_id == movie_id
                                         ).all()


if __name__ == '__main__':
    from server import app
    connect_to_db(app)
