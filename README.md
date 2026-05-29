# Demographix

![demographix_gif](https://github.com/mithintv/demographix/assets/13951154/5f264930-6b95-4e2d-ad81-dec2142ae066)
Demographix is a data visualization tool designed to showcase demographics of on-screen cast members in popular Hollywood movies. The project uses a React 18 + Vite 6 frontend, a Flask 3 API on Python 3.13, and a PostgreSQL database modeled with SQLAlchemy 2. The app also uses TMDB and Google's Gemini to retrieve and enrich demographic data.

## Local Development

Install [Overmind](https://github.com/DarthSim/overmind) before starting both local processes:

```sh
brew install overmind
```

**overmind** (Go-based, supports attaching to individual processes):
```sh
overmind start
```

Backend dependencies are managed with Poetry from `api/`; frontend dependencies are managed with pnpm from `client/`.
