dropdb -f demographix
createdb demographix
psql -d demographix -f demographix.sql
flask db upgrade
