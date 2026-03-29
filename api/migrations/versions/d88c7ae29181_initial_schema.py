"""initial schema

Revision ID: d88c7ae29181
Revises:
Create Date: 2026-03-21 15:54:50.396675

"""

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision = "d88c7ae29181"
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    op.create_table(
        "regions",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(length=15), nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "subregions",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(length=25), nullable=False),
        sa.Column("region_id", sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(["region_id"], ["regions.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "genders",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(length=20), nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "races",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(length=75), nullable=False),
        sa.Column("short", sa.String(length=5), nullable=False),
        sa.Column("description", sa.String(), nullable=False),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("short"),
    )
    op.create_table(
        "sources",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(length=25), nullable=False),
        sa.Column("domain", sa.String(), nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "countries",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(length=75), nullable=False),
        sa.Column("cca3", sa.String(length=3), nullable=False),
        sa.Column("demonym", sa.String(length=75), nullable=False),
        sa.Column("region_id", sa.Integer(), nullable=False),
        sa.Column("subregion_id", sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(["region_id"], ["regions.id"]),
        sa.ForeignKeyConstraint(["subregion_id"], ["subregions.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "ethnicities",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(length=75), nullable=False),
        sa.Column("region_id", sa.Integer(), nullable=True),
        sa.Column("subregion_id", sa.Integer(), nullable=True),
        sa.ForeignKeyConstraint(["region_id"], ["regions.id"]),
        sa.ForeignKeyConstraint(["subregion_id"], ["subregions.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "movies",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("imdb_id", sa.String(length=15), nullable=False),
        sa.Column("title", sa.String(length=255), nullable=False),
        sa.Column("overview", sa.String(), nullable=False),
        sa.Column("runtime", sa.Integer(), nullable=False),
        sa.Column("poster_path", sa.String(), nullable=False),
        sa.Column("release_date", sa.DateTime(), nullable=False),
        sa.Column("budget", sa.BigInteger(), nullable=False),
        sa.Column("revenue", sa.BigInteger(), nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "genres",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(length=15), nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "nominations",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(length=25), nullable=False),
        sa.Column("year", sa.Integer(), nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "source_links",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("source_id", sa.Integer(), nullable=False),
        sa.Column("link", sa.String(), nullable=False),
        sa.ForeignKeyConstraint(["source_id"], ["sources.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "cast_members",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("imdb_id", sa.String(length=15), nullable=True),
        sa.Column("name", sa.String(length=50), nullable=False),
        sa.Column("gender_id", sa.Integer(), nullable=False),
        sa.Column("birthday", sa.DateTime(), nullable=True),
        sa.Column("deathday", sa.DateTime(), nullable=True),
        sa.Column("biography", sa.String(), nullable=True),
        sa.Column("country_of_birth_id", sa.String(length=3), nullable=True),
        sa.Column("profile_path", sa.String(length=35), nullable=True),
        sa.ForeignKeyConstraint(["gender_id"], ["genders.id"]),
        sa.ForeignKeyConstraint(["country_of_birth_id"], ["countries.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "credits",
        sa.Column("id", sa.String(), nullable=False),
        sa.Column("movie_id", sa.Integer(), nullable=False),
        sa.Column("character", sa.String(length=75), nullable=False),
        sa.Column("order", sa.Integer(), nullable=False),
        sa.Column("cast_member_id", sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(["movie_id"], ["movies.id"]),
        sa.ForeignKeyConstraint(["cast_member_id"], ["cast_members.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "media_genres",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("genre_id", sa.Integer(), nullable=False),
        sa.Column("movie_id", sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(["genre_id"], ["genres.id"]),
        sa.ForeignKeyConstraint(["movie_id"], ["movies.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "movie_nominations",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("movie_id", sa.Integer(), nullable=False),
        sa.Column("nomination_id", sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(["movie_id"], ["movies.id"]),
        sa.ForeignKeyConstraint(["nomination_id"], ["nominations.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint(
            "movie_id", "nomination_id", name="unique_movie_id_nomination_id"
        ),
    )
    op.create_table(
        "cast_races",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("race_id", sa.Integer(), nullable=False),
        sa.Column("cast_member_id", sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(["race_id"], ["races.id"]),
        sa.ForeignKeyConstraint(["cast_member_id"], ["cast_members.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "cast_ethnicities",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("ethnicity_id", sa.Integer(), nullable=False),
        sa.Column("cast_member_id", sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(["ethnicity_id"], ["ethnicities.id"]),
        sa.ForeignKeyConstraint(["cast_member_id"], ["cast_members.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "cast_ethnicity_source_links",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("source_link_id", sa.Integer(), nullable=False),
        sa.Column("cast_ethnicity_id", sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(["source_link_id"], ["source_links.id"]),
        sa.ForeignKeyConstraint(["cast_ethnicity_id"], ["cast_ethnicities.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "also_known_as",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(), nullable=False),
        sa.Column("cast_member_id", sa.Integer(), nullable=False),
        sa.ForeignKeyConstraint(["cast_member_id"], ["cast_members.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "alt_countries",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("country_id", sa.Integer(), nullable=False),
        sa.Column("alt_name", sa.String(length=75), nullable=False),
        sa.ForeignKeyConstraint(["country_id"], ["countries.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "alt_ethnicities",
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("ethnicity_id", sa.Integer(), nullable=False),
        sa.Column("alt_name", sa.String(length=75), nullable=False),
        sa.ForeignKeyConstraint(["ethnicity_id"], ["ethnicities.id"]),
        sa.PrimaryKeyConstraint("id"),
    )


def downgrade():
    op.drop_table("alt_ethnicities")
    op.drop_table("alt_countries")
    op.drop_table("also_known_as")
    op.drop_table("cast_ethnicity_source_links")
    op.drop_table("cast_ethnicities")
    op.drop_table("cast_races")
    op.drop_table("movie_nominations")
    op.drop_table("media_genres")
    op.drop_table("credits")
    op.drop_table("cast_members")
    op.drop_table("source_links")
    op.drop_table("nominations")
    op.drop_table("genres")
    op.drop_table("movies")
    op.drop_table("ethnicities")
    op.drop_table("countries")
    op.drop_table("sources")
    op.drop_table("races")
    op.drop_table("genders")
    op.drop_table("subregions")
    op.drop_table("regions")
