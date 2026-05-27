"""Optional Redis-backed cache helpers."""

from __future__ import annotations

import json
import os
from dataclasses import fields, is_dataclass
from datetime import date, datetime
from typing import Any

import redis

from api.services.logging_service import get_logger

logger = get_logger(__name__)

KEY_PREFIX = os.environ.get("CACHE_KEY_PREFIX", "demographix")
REDIS_URL = os.environ.get("REDIS_URL")

_client = None
_client_initialized = False
_redis_error_classes: tuple[type[Exception], ...] = (Exception,)


def _json_default(value: Any):
    if is_dataclass(value) and not isinstance(value, type):
        return {field.name: getattr(value, field.name) for field in fields(value)}
    if isinstance(value, (date, datetime)):
        return value.isoformat()
    raise TypeError(f"Object of type {type(value).__name__} is not JSON serializable")


def _get_client():
    global _client, _client_initialized, _redis_error_classes

    if _client_initialized:
        return _client

    _client_initialized = True
    if REDIS_URL is None:
        logger.info("Cache disabled", reason="REDIS_URL is not configured")
        return None

    try:
        _redis_error_classes = (redis.RedisError,)
        _client = redis.Redis.from_url(
            REDIS_URL,
            decode_responses=True,
            socket_connect_timeout=1,
            socket_timeout=1,
        )
        _client.ping()
        logger.info("Cache enabled")
    except ImportError:
        logger.warning("Cache disabled", reason="Redis package is not installed")
        _client = None
    except _redis_error_classes as e:
        logger.warning("Cache unavailable", error=str(e))
        _client = None

    return _client


def get_json(key: str):
    key = f"{KEY_PREFIX}:{key}"
    client = _get_client()
    if client is None:
        return None

    try:
        value = client.get(key)
    except _redis_error_classes as e:
        logger.warning("Cache get_json failed", key=key, error=str(e))
        return None

    if value is None:
        logger.info("Cache miss", key=key)
        return None

    if not isinstance(value, (str, bytes, bytearray)):
        logger.warning(
            "Cache get_json invalid type", key=key, value_type=type(value).__name__
        )
        return None

    logger.info("Cache hit %s", key)
    return json.loads(value)


def set_json(key: str, value: Any, ttl_seconds: int | None = None):
    key = f"{KEY_PREFIX}:{key}"
    client = _get_client()
    if client is None:
        return

    try:
        client.set(
            key,
            json.dumps(value, default=_json_default),
            ex=ttl_seconds,
        )
    except (TypeError, *_redis_error_classes) as e:
        logger.warning("Cache set_json failed", key=key, error=str(e))


def delete(key: str):
    key = f"{KEY_PREFIX}:{key}"
    client = _get_client()
    if client is None:
        return

    try:
        client.delete(key)
    except _redis_error_classes as e:
        logger.warning("Cache delete failed", key=key, error=str(e))
