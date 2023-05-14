"""CRUD operations."""

from model import db, Movie, Credit, CastMember, Gender, Country, connect_to_db


def get_movies():
    """Return all movies."""

    return Movie.query.all()


def get_movie_credits():
    """Return movies with credits."""

    return db.session.query(Movie,
                            Credit).join(Credit).all()


def get_movie_cast(movie_id):
    """Return specific movie with credits and cast member details."""

    movie = Movie.query.filter(Movie.movie_id == movie_id).one()
    cast_list = db.session.query(
        CastMember,
        Gender,
        Country,
        Credit
    ).join(Gender, Gender.gender_id == CastMember.gender_id
           ).join(Country, Country.country_id == CastMember.country_of_birth_id
                  ).join(Credit, Credit.cast_member_id == CastMember.cast_member_id
                         ).join(Movie, Movie.movie_id == Credit.movie_id
                                ).filter(Movie.movie_id == movie_id
                                         ).all()
    print(cast_list)
    cast_details = []
    for cast in cast_list:
        new_cast = {'name': cast.CastMember.name,
                    'birthday': cast.CastMember.birthday,
                    'gender': cast.Gender.name,
                    'country_of_birth': cast.Country.name,
                    'character': cast.Credit.character,
                    'order': cast.Credit.order}
        cast_details.append(new_cast)

    data = {
        'title': movie.title,
        'overview': movie.overview,
        'runtime': movie.runtime,
        'poster_path': movie.poster_path,
        'release_date': movie.release_date,
        'budget': movie.budget,
        'revenue': movie.revenue,
        'cast': cast_details
    }
    print(data)
    return data


if __name__ == '__main__':
    from server import app
    connect_to_db(app)
