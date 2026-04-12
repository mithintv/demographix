"""Shared SQLAlchemy instance."""

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import MetaData

convention = {
    "uq": "uq_%(table_name)s_%(column_0_name)s",
    "ix": "ix_%(column_0_label)s",
    "fk": "fk_%(table_name)s_%(column_0_name)s",
    "pk": "pk_%(table_name)s",
    "ck": "ck_%(table_name)s_%(constraint_name)s",
}

db = SQLAlchemy(metadata=MetaData(naming_convention=convention))
