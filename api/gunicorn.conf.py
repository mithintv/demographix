import logging
import os

from api.services.logging_service import configure_logging

bind = os.environ["GUNICORN_BIND"]


class StructlogGunicornLogger:
    """Gunicorn logger_class that routes all logs through structlog."""

    def __init__(self, cfg):
        from gunicorn.glogging import Logger

        self._logger = Logger(cfg)
        configure_logging()
        self.error_log = logging.getLogger("gunicorn.error")
        self.access_log = logging.getLogger("gunicorn.access")
        self.cfg = cfg

    def __getattr__(self, name):
        return getattr(self._logger, name)

    def access(self, resp, req, environ, request_time):
        from urllib.parse import parse_qs

        method = environ.get("REQUEST_METHOD")
        path = environ.get("PATH_INFO")
        status = resp.status_code
        elapsed = round(request_time.total_seconds() * 1000, 2)
        query_string = environ.get("QUERY_STRING", "")
        query_params = {
            k: v[0] if len(v) == 1 else v for k, v in parse_qs(query_string).items()
        }

        if os.environ.get("FLASK_ENV") != "production":
            _R = "\033[0m"
            _C = "\033[36m"
            _G, _Y, _E = "\033[32m", "\033[33m", "\033[31m"
            sc = _G if status < 400 else (_Y if status < 500 else _E)
            qs = f"?{query_string}" if query_string else ""
            self.access_log.info(
                "HTTP %s%s%s %s%s%s %s%s%s in %s%s%s ms",
                _C,
                method,
                _R,
                _C,
                path + qs,
                _R,
                sc,
                status,
                _R,
                _C,
                elapsed,
                _R,
            )
        else:
            self.access_log.info(
                "HTTP %s %s %s in %s ms",
                method,
                path,
                status,
                elapsed,
                extra={
                    "request_method": method,
                    "request_path": path,
                    "request_query_params": query_params,
                    "status_code": status,
                    "elapsed_ms": elapsed,
                },
            )


logger_class = StructlogGunicornLogger
