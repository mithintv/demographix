import unittest

import data.ethnicity


class TestEthniCelebs(unittest.TestCase):
    def test_parse_ethnicelebs(self):
        self.assertCountEqual(
            data.ethnicity.parse_ethnicelebs(
                """Ethnicity:\n*50% Italian\n*25% French Breton\n*25% unclear; possibly German or Ashkenazi Jewish"""
            ),
            ["Italian", "German", "French Breton", "Ashkenazi Jewish"],
        )
        self.assertCountEqual(
            data.ethnicity.parse_ethnicelebs(
                """Ethnicity:\nEnglish, some Welsh, Scottish, possibly distant Irish"""
            ),
            ["English", "Welsh", "Scottish", "Irish"],
        )
        self.assertCountEqual(
            data.ethnicity.parse_ethnicelebs(
                """Ethnicity:\nDominican Republic, Puerto Rican, evidently small amount of Lebanese and Haitian"""
            ),
            ["Lebanese", "Haitian", "Puerto Rican", "Dominican Republic"],
        )
        self.assertCountEqual(
            data.ethnicity.parse_ethnicelebs(
                """Ethnicity:\n*father – English, Norwegian, German, Swiss-German, French-Canadian\n*mother – Norwegian"""
            ),
            ["English", "Norwegian", "German", "Swiss", "Canadian", "French"],
        )
        self.assertCountEqual(
            data.ethnicity.parse_ethnicelebs(
                """Ethnicity:\n*biological father – African-American, possibly other\n*mother – Scottish, English, German, Irish, Austrian"""
            ),
            ["African American", "Scottish", "English", "German", "Irish", "Austrian"],
        )


if __name__ == "__main__":
    unittest.main()
    unittest.main()
