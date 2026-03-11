from api.data.model import db


class Credit(db.Model):
    """A credit."""

    __tablename__ = "credits"

    id = db.Column(db.String(), primary_key=True)
    movie_id = db.Column(db.Integer, db.ForeignKey("movies.id"), nullable=False)
    character = db.Column(db.String(75))
    order = db.Column(db.Integer)
    cast_member_id = db.Column(
        db.Integer, db.ForeignKey("cast_members.id"), nullable=False
    )

    movie = db.relationship("Movie", uselist=False, back_populates="credits")
    cast_member = db.relationship("CastMember", uselist=False, back_populates="credits")

    def __repr__(self):
        return f"<Credit id={self.id} character={self.character}>"
