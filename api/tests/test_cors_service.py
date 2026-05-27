import unittest

from api.services.cors_service import (
    DEFAULT_DEV_ORIGINS,
    get_cors_origins,
    parse_cors_origins,
)


class TestCorsService(unittest.TestCase):
    def test_parse_cors_origins_trims_whitespace_and_ignores_empty_entries(self):
        self.assertEqual(
            parse_cors_origins(
                "https://demographix.example.com, https://www.demographix.example.com, ,"
            ),
            [
                "https://demographix.example.com",
                "https://www.demographix.example.com",
            ],
        )

    def test_get_cors_origins_prefers_configured_origins(self):
        self.assertEqual(
            get_cors_origins(
                {
                    "CORS_ORIGINS": "https://app.example.com,https://preview.example.com",
                    "FLASK_ENV": "production",
                    "CLIENT_HOSTNAME": "https://fallback.example.com",
                }
            ),
            ["https://app.example.com", "https://preview.example.com"],
        )

    def test_get_cors_origins_uses_local_defaults_without_config_in_production(self):
        self.assertEqual(
            get_cors_origins(
                {
                    "FLASK_ENV": "production",
                    "CLIENT_HOSTNAME": "https://app.example.com",
                }
            ),
            DEFAULT_DEV_ORIGINS,
        )

    def test_get_cors_origins_uses_local_defaults_without_config(self):
        self.assertEqual(
            get_cors_origins({"FLASK_ENV": "development"}), DEFAULT_DEV_ORIGINS
        )


if __name__ == "__main__":
    unittest.main()
