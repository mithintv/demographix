## Local Development

### Run

Use either [honcho](https://honcho.readthedocs.io/) or [overmind](https://github.com/DarthSim/overmind) to start all processes defined in `Procfile` (API + Vite frontend):

**honcho** (Python, installed via poetry):
```sh
poetry run honcho start
```

## CORS

The API accepts multiple allowed CORS origins through a comma-separated
`CORS_ORIGINS` environment variable:

```sh
CORS_ORIGINS=https://demographix.example.com,https://www.demographix.example.com
```

When `CORS_ORIGINS` is not set, the API falls back to the local development
origins `http://localhost:5173` and `http://localhost:4173`.

## Database

### Initialize/Reload DB

`scripts/reload_db.sh` drops and recreates the database via Docker, then applies all migrations:

```sh
./scripts/reload_db.sh
```

This drops the `demographix` database in the `postgres` Docker container, recreates it, and runs `flask db upgrade`.

### Seeding

Run from the repo root (`/demographix`). Seeds all reference tables (regions, countries, ethnicities, races, genders, genres, events/awards):

```sh
./scripts/seed_db.sh
```
