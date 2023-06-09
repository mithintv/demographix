"""Rename cast_ethnicity key in source_links

Revision ID: ec16aefe0020
Revises: e0b52900e381
Create Date: 2023-05-22 15:04:08.241335

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'ec16aefe0020'
down_revision = 'e0b52900e381'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('source_links', schema=None) as batch_op:
        batch_op.add_column(sa.Column('cast_ethnicity_id', sa.Integer(), nullable=True))
        batch_op.drop_constraint('source_links_cast_ethnicity_fkey', type_='foreignkey')
        batch_op.create_foreign_key(None, 'cast_ethnicities', ['cast_ethnicity_id'], ['id'])
        batch_op.drop_column('cast_ethnicity')

    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('source_links', schema=None) as batch_op:
        batch_op.add_column(sa.Column('cast_ethnicity', sa.INTEGER(), autoincrement=False, nullable=True))
        batch_op.drop_constraint(None, type_='foreignkey')
        batch_op.create_foreign_key('source_links_cast_ethnicity_fkey', 'cast_ethnicities', ['cast_ethnicity'], ['id'])
        batch_op.drop_column('cast_ethnicity_id')

    # ### end Alembic commands ###
