## Local Development

### Run

Use either [honcho](https://honcho.readthedocs.io/) or [overmind](https://github.com/DarthSim/overmind) to start all processes defined in `Procfile` (API + Vite frontend):

**honcho** (Python, installed via poetry):
```sh
poetry run honcho start
```

**overmind** (Go-based, supports attaching to individual processes):
```sh
overmind start
```

To attach to a specific process (e.g. to see logs or send input):
```sh
overmind connect api
overmind connect web
```

### Environment Variables

Environment variables are loaded from `api/.env`. Both honcho and overmind automatically read this file when starting processes.

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
python -m api.scripts.seed.seed
```
