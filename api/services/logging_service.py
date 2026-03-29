"""Structured logging configuration."""

import logging
import os

import structlog


def configure_logging():
    is_production = os.environ.get("FLASK_ENV") == "production"
    renderer = (
        structlog.processors.JSONRenderer()
        if is_production
        else structlog.dev.ConsoleRenderer()
    )

    structlog.configure(
        processors=[
            structlog.contextvars.merge_contextvars,
            structlog.stdlib.add_log_level,
            structlog.stdlib.add_logger_name,
            structlog.processors.TimeStamper(fmt="iso"),
            renderer,
        ],
        wrapper_class=structlog.make_filtering_bound_logger(logging.INFO),
        context_class=dict,
        logger_factory=structlog.stdlib.LoggerFactory(),
    )

    handler = logging.StreamHandler()
    handler.setFormatter(
        structlog.stdlib.ProcessorFormatter(
            processors=[
                *([structlog.stdlib.ExtraAdder()] if is_production else []),
                structlog.stdlib.ProcessorFormatter.remove_processors_meta,
                renderer,
            ],
            foreign_pre_chain=[
                structlog.stdlib.add_log_level,
                structlog.stdlib.add_logger_name,
                structlog.processors.TimeStamper(fmt="iso"),
            ],
        )
    )
    root_logger = logging.getLogger()
    root_logger.handlers.clear()
    root_logger.addHandler(handler)

    for name in ("gunicorn", "gunicorn.access", "gunicorn.error"):
        gunicorn_logger = logging.getLogger(name)
        gunicorn_logger.handlers.clear()
        gunicorn_logger.propagate = True


def get_logger(name: str = __name__) -> structlog.typing.FilteringBoundLogger:
    return structlog.get_logger(name)
