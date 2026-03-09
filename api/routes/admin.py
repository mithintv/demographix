"""Admin routes for data validity checking."""

from flask import Blueprint, jsonify, request

from api.data.model import CastEthnicity, CastEthnicitySourceLink, CastMember, Movie, db
from api.data.nominations.model import MovieNomination, Nomination
from api.data.nominations.repository import query_nominations

bp = Blueprint("admin", __name__, url_prefix="/admin")


@bp.route("/cast")
def list_cast():
    """Return paginated list of cast members with demographic data."""
    page = int(request.args.get("page", 1))
    per_page = int(request.args.get("per_page", 50))
    search = request.args.get("search", "").strip()
    flag = request.args.get("flag", "").strip()

    query = db.session.query(CastMember)
    if search:
        query = query.filter(CastMember.name.ilike(f"%{search}%"))
    if flag == "missing_data":
        query = query.filter(~CastMember.ethnicities.any())
    elif flag == "no_sources":
        missing_source_ids = (
            db.session.query(CastEthnicity.cast_member_id)
            .outerjoin(
                CastEthnicitySourceLink,
                CastEthnicity.id == CastEthnicitySourceLink.cast_ethnicity_id,
            )
            .filter(CastEthnicitySourceLink.id.is_(None))
            .subquery()
        )
        query = query.filter(
            CastMember.ethnicities.any(),
            CastMember.id.in_(missing_source_ids),
        )

    total = query.count()
    cast_members = (
        query.order_by(CastMember.name)
        .offset((page - 1) * per_page)
        .limit(per_page)
        .all()
    )

    result = []
    for cm in cast_members:
        ethnicities = []
        has_sources = True
        for ce in cm.ethnicities:
            source_count = len(ce.sources)
            if source_count == 0:
                has_sources = False
            ethnicities.append(
                {
                    "cast_ethnicity_id": ce.id,
                    "ethnicity_id": ce.ethnicity_id,
                    "ethnicity_name": ce.ethnicity.name if ce.ethnicity else None,
                    "source_count": source_count,
                }
            )

        result.append(
            {
                "id": cm.id,
                "name": cm.name,
                "gender_id": cm.gender_id,
                "gender": cm.gender.name if cm.gender else None,
                "country_of_birth_id": cm.country_of_birth_id,
                "country_of_birth": (
                    cm.country_of_birth.name if cm.country_of_birth else None
                ),
                "ethnicities": ethnicities,
                "races": [r.name for r in cm.races],
                "has_sources": has_sources and len(ethnicities) > 0,
                "missing_data": len(ethnicities) == 0,
            }
        )

    return jsonify({"cast": result, "total": total, "page": page, "per_page": per_page})


@bp.route("/cast/<int:cast_id>", methods=["PATCH"])
def update_cast(cast_id):
    """Update a cast member's gender or country of birth."""
    cm = db.session.get(CastMember, cast_id)
    if not cm:
        return jsonify({"error": "Not found"}), 404

    data = request.get_json()
    if "gender_id" in data:
        cm.gender_id = data["gender_id"]
    if "country_of_birth_id" in data:
        cm.country_of_birth_id = data["country_of_birth_id"] or None

    db.session.commit()
    return jsonify({"id": cm.id, "name": cm.name})


@bp.route("/cast/<int:cast_id>/ethnicities/<int:cast_ethnicity_id>", methods=["DELETE"])
def delete_ethnicity(cast_id, cast_ethnicity_id):
    """Remove an ethnicity assignment from a cast member."""
    ce = (
        db.session.query(CastEthnicity)
        .filter_by(id=cast_ethnicity_id, cast_member_id=cast_id)
        .first()
    )
    if not ce:
        return jsonify({"error": "Not found"}), 404

    db.session.delete(ce)
    db.session.commit()
    return jsonify({"deleted": cast_ethnicity_id})


@bp.route("/nominations")
def get_nominations():
    """Return nominations grouped by award name, with their associated movies."""
    search = request.args.get("search", "").strip()
    results = query_nominations(search)
    return jsonify({"nominations": results, "total": len(results)})


@bp.route("/nominations/<int:nomination_id>", methods=["DELETE"])
def delete_nomination(nomination_id):
    """Delete a nomination and its movie associations."""
    nom = db.session.get(Nomination, nomination_id)
    if not nom:
        return jsonify({"error": "Not found"}), 404

    db.session.query(MovieNomination).filter_by(nomination_id=nomination_id).delete()
    db.session.delete(nom)
    db.session.commit()
    return jsonify({"deleted": nomination_id})


@bp.route("/nominations", methods=["POST"])
def create_nomination():
    """Create a new nomination."""
    data = request.get_json()
    name = (data.get("name") or "").strip()
    year = data.get("year")

    if not name or not year:
        return jsonify({"error": "name and year are required"}), 400

    nom = Nomination(name=name, year=int(year))
    db.session.add(nom)
    db.session.commit()
    return jsonify({"id": nom.id, "name": nom.name, "year": nom.year}), 201


@bp.route("/nominations/<int:nomination_id>/movies", methods=["POST"])
def add_movie_to_nomination(nomination_id):
    """Add a movie to a nomination."""
    nom = db.session.get(Nomination, nomination_id)
    if not nom:
        return jsonify({"error": "Not found"}), 404

    data = request.get_json()
    movie_id = data.get("movie_id")
    if not movie_id:
        return jsonify({"error": "movie_id is required"}), 400

    movie = db.session.get(Movie, movie_id)
    if not movie:
        return jsonify({"error": "Movie not found"}), 404

    existing = (
        db.session.query(MovieNomination)
        .filter_by(nomination_id=nomination_id, movie_id=movie_id)
        .first()
    )
    if existing:
        return jsonify({"error": "Movie already linked"}), 409

    mn = MovieNomination(nomination_id=nomination_id, movie_id=movie_id)
    db.session.add(mn)
    db.session.commit()
    return jsonify({"nomination_id": nomination_id, "movie_id": movie_id}), 201


@bp.route("/nominations/<int:nomination_id>/movies/<int:movie_id>", methods=["DELETE"])
def remove_movie_from_nomination(nomination_id, movie_id):
    """Remove a movie from a nomination."""
    mn = (
        db.session.query(MovieNomination)
        .filter_by(nomination_id=nomination_id, movie_id=movie_id)
        .first()
    )
    if not mn:
        return jsonify({"error": "Not found"}), 404

    db.session.delete(mn)
    db.session.commit()
    return jsonify({"deleted": movie_id})


@bp.route("/movies")
def search_movies():
    """Search movies by title."""
    search = request.args.get("search", "").strip()
    if not search:
        return jsonify([])

    movies = (
        db.session.query(Movie)
        .filter(Movie.title.ilike(f"%{search}%"))
        .order_by(Movie.title)
        .limit(20)
        .all()
    )
    return jsonify(
        [
            {
                "id": m.id,
                "title": m.title,
                "release_date": m.release_date.isoformat() if m.release_date else None,
            }
            for m in movies
        ]
    )
