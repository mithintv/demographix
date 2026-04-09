"""Structured logging configuration."""

import logging
import os
import re
import sys

import structlog


def _clean_werkzeug_message(logger, method, event_dict):
    msg = event_dict.get("event", "")
    msg = re.sub(r" \[\d{2}/\w+/\d{4} \d{2}:\d{2}:\d{2}\]", "", msg)
    msg = re.sub(r" - -", " -", msg)
    event_dict["event"] = msg
    return event_dict


def _is_gunicorn() -> bool:
    return "gunicorn" in sys.modules


def configure_logging():
    structlog.configure(
        processors=[
            structlog.contextvars.merge_contextvars,
            structlog.stdlib.add_log_level,
            structlog.stdlib.add_logger_name,
            structlog.processors.TimeStamper(fmt="iso"),
            structlog.stdlib.ProcessorFormatter.wrap_for_formatter,
        ],
        wrapper_class=structlog.make_filtering_bound_logger(logging.INFO),
        context_class=dict,
        logger_factory=structlog.stdlib.LoggerFactory(),
    )

    is_production = os.environ.get("FLASK_ENV") == "production"
    renderer = (
        structlog.processors.JSONRenderer()
        if is_production
        else structlog.dev.ConsoleRenderer()
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
                _clean_werkzeug_message,
            ],
        )
    )
    root_logger = logging.getLogger()
    root_logger.setLevel(logging.INFO)
    root_logger.handlers.clear()
    root_logger.addHandler(handler)

    server_loggers = (
        ("gunicorn", "gunicorn.access", "gunicorn.error")
        if _is_gunicorn()
        else ("werkzeug",)
    )
    for name in server_loggers:
        logger = logging.getLogger(name)
        logger.handlers.clear()
        logger.propagate = True


def get_logger(name: str = __name__) -> structlog.typing.FilteringBoundLogger:
    return structlog.get_logger(name)
