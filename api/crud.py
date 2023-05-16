"""CRUD operations."""

from sqlalchemy import func, and_, or_
from model import db, Movie, Credit, CastMember, Gender, Ethnicity, CastEthnicity, Country, connect_to_db


def get_regions():
    """Return all regions and subregions"""

    print(db.session.query(Country.subregion, Country.region).group_by(
        Country.subregion, Country.region).order_by(Country.subregion.asc()).all())
    return db.session.query(Country.subregion, Country.region).group_by(Country.subregion, Country.region).order_by(Country.subregion.asc()).all()


def get_movies():
    """Return all movies."""

    return Movie.query.all()


def query_movie(keywords):
    """Return search query results."""

    filters = [func.lower(Movie.title).like(
        f'%{keyword.lower()}%') for keyword in keywords]
    return Movie.query.filter(or_(*filters)).all()


def get_movie_cast(movie_id):
    """Return specific movie with credits and cast member details."""

    movie = Movie.query.filter(Movie.id == movie_id).one()
    cast_list = db.session.query(
        CastMember,
        Gender,
        Country,
        Credit
    ).join(Gender, Gender.id == CastMember.gender_id
           ).join(Country, Country.id == CastMember.country_of_birth_id
                  ).join(Credit, Credit.cast_member_id == CastMember.id
                         ).join(Movie, Movie.id == Credit.movie_id
                                ).filter(Movie.id == movie_id
                                         ).all()

    cast_details = []
    for cast in cast_list:

        cast_member = CastMember.query.filter(
            CastMember.id == cast.CastMember.id).one()
        ethnicities = [ethnicity.name for ethnicity in cast_member.ethnicities]
        races = [race.name for race in cast_member.races]

        new_cast = {'name': cast.CastMember.name,
                    'birthday': cast.CastMember.birthday,
                    'gender': cast.Gender.name,
                    'ethnicity': ethnicities,
                    'race': races,
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
