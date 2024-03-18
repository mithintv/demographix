# Contributing
Please take a moment to review this document in order to make the contribution process easy and effective for everyone involved. Following these guidelines helps to communicate that you respect the time of all of the developers managing and developing this open-source project.

<a id="contents"></a>
## Contents

- [Tech Stack](#tech-stack)
- [Development Environment](#dev-env)
- [Pull Requests](#pull-requests)

<a id="tech-stack"></a>

## Tech stack [`⇧`](#contents)

Frontend

- [React](https://react.dev/) v16
- [React Router](https://reactrouter.com/en/main) v5.3.4
- [Recharts](https://recharts.org/en-US/)
- [Material UI](https://mui.com/)

Backend

- [Python](https://docs.python.org/3/) v3.9.4
- [Flask](https://flask.palletsprojects.com/en/2.3.x/) v2.0.1
- [PostgreSQL](https://www.postgresql.org/docs/)
- [SQLAlchemy](https://docs.sqlalchemy.org/en/20/)  v1.4.18
- [Beautiful Soup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/) v4.12.2

<a id="dev-env"></a>

## Development environment [`⇧`](#contents)

To setup your development environment, install Python3, Postgres and [direnv](https://direnv.net/).

For windows users, I recommend developing in WSL. Click [here](https://learn.microsoft.com/en-us/windows/wsl/setup/environment) to view the instructions on setting up WSL 2 for development.

1. Clone the repo

   ```bash
   # Clone your fork of the repo into the current directory
   git clone https://github.com/mithintv/demographix

   # Navigate to the newly cloned directory
   cd demographix
   ```

2. Create sh files for environment variables namely api keys and access tokens. [The Movie Database API](https://developer.themoviedb.org/docs) provides api keys and access tokens for free.

   ```bash
   cat > api/secrets.sh << EOL
   export FLASK_ENV=development
   export FLASK_DEBUG=1

   export TMDB_ACCESS_TOKEN=<your-TMDB-access-token>
   export TMDB_API_KEY=<your-TMDB-api-key>
   EOL
   ```

3. Create local database and seed it with sample data

   ```bash
   createdb demographix
   psql -U <username> -d demographix -f demographix.sql
   ```

4. Setup and activate virtual environment

   ```bash
   python3 -m venv api/.venv
   ```

5. Activate environment, configure variables, and install dependencies. Changing the directory into `/api` should launch direnv via `.envrc` and activate the virtual environment and configure the environment variables.

   ```bash
   cd api/
   pip install -r requirements.txt
   ```

6. Run server

   ```bash
   flask run
   ```
   You now have a fully running local copy of demographix running on http://localhost:5000. In the future, you should be able to just navigate to `/api` and run `flask run`.

<a id="pull-requests"></a>

## Pull Requests [`⇧`](#contents)

1. Get the latest changes from upstream develop branch:

   ```bash
   git checkout develop
   git pull upstream develop
   ```

2. Create a new topic branch (off the develop branch) to contain your feature, change, or fix:

   ```bash
   git switch -c <topic-branch-name>
   ```

3. Commit your changes in logical chunks, and please try to adhere to [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). Use Git's [interactive rebase](https://docs.github.com/en/github/getting-started-with-github/about-git-rebase) feature to tidy up your commits before making them public.

4. Locally rebase the upstream development branch into your topic branch:

   ```bash
   git pull --rebase upstream develop
   ```

5. Push your topic branch up to your fork:

   ```bash
   git push origin <topic-branch-name>
   ```

6. [Open a Pull Request](https://help.github.com/articles/using-pull-requests/) with a clear title and description.

Thank you in advance for your contributions!
