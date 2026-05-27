import os
from collections.abc import Mapping


DEFAULT_DEV_ORIGINS = ["http://localhost:5173", "http://localhost:4173"]


def parse_cors_origins(value: str | None) -> list[str]:
    if not value:
        return []

    return [origin.strip() for origin in value.split(",") if origin.strip()]


def get_cors_origins(env: Mapping[str, str] = os.environ) -> list[str]:
    cors_origins = parse_cors_origins(env.get("CORS_ORIGINS"))
    if cors_origins:
        return cors_origins

    return DEFAULT_DEV_ORIGINS
