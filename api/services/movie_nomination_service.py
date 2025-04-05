from api.data.model import MovieNomination, Nomination, db
from api.services.movie_service import movie_service


class MovieNominationService:
    """Service to retrieve movie nomination data from database."""

    def __init__(self):
        self.db = db.session

    def get_nom_movies(self, event: str, year: int) -> list[MovieNomination]:
        """Return nominated movies and cast demographics for a given year from database. Returns an empty List if nomination year and event combination does not exist in the database."""

        nomination = Nomination.query.filter(
            Nomination.year == year and Nomination.name == event.replace("-", " ")
        ).first()
        if nomination is None:
            return []

        movie_noms = MovieNomination.query.filter(
            MovieNomination.nomination_id == nomination.id
        ).all()

        # Check if there are movies to add if less than 5 nominees
        # if len(movie_noms) < 5:
        #     check_nominations(int(year))
        #     movie_noms = MovieNomination.query.filter(
        #         MovieNomination.nomination_id == nomination.id
        #     ).all()
        #     logging.info(len(movie_noms))

        all_movie_data = []
        for movie_nom in movie_noms:
            movie_data = movie_service.get_movie_and_cast_by_id(movie_nom.movie_id)
            all_movie_data.append(movie_data)

        return all_movie_data


movie_nomination_service = MovieNominationService()
