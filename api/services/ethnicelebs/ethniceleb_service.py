import logging
import re
import unicodedata

import requests
from api.data.cast_members.cast_member_repository import CastEthnicityList
from bs4 import BeautifulSoup


def check_ethnicelebs(given_name: str):
    """Given cast name, use ethnicelebs.com to return list of ethnicity data."""

    logging.info("Stripping accents from %s", given_name)
    stripped_name = "".join(
        c
        for c in unicodedata.normalize("NFD", given_name)
        if unicodedata.category(c) != "Mn"
    )
    person_name = stripped_name.lower().replace(" ", "-").replace(".", "")

    logging.info("Attempting %s on ethnicelebs.com", person_name)
    url = f"https://ethnicelebs.com/{person_name}"
    response = requests.get(
        url,
        headers={
            "Content-Type": "text/html",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
        },
        timeout=15,
    )
    soup = BeautifulSoup(response.text, features="html.parser")

    if response.status_code == 200 and len(response.url) == len(url):
        if soup.strong is not None:
            ethnicity_description = soup.strong.get_text()
            logging.info(
                "Raw text from ethnicelebs: %s",
                ethnicity_description.replace("\n", " "),
            )

            cast_ethnicity_list: CastEthnicityList = {
                "list": parse_ethniceleb_ethnicities(ethnicity_description),
                "source": response.url,
            }
            return cast_ethnicity_list

        else:
            logging.info(
                "Page was loaded but no ethnicity information on ethnicelebs.com"
            )
            return None

    else:
        if len(response.url) != len(url):
            logging.info(
                "Request aborted due to URL change... Request URL: %s Response URL: %s",
                url,
                response.url,
            )
        if response.status_code == 404:
            logging.info("Could not find %s on ethnicelebs.com", person_name)
        return None


def parse_ethniceleb_ethnicities(txt):
    """Parse <strong> block in ethnicelebs.com to return ethnicity list."""

    ethnicity_list: set[str] = set([])
    _, ethnicities = txt.split(":")
    all_words = re.split(r"[\,\*/\[\]]|\band\b|\bor\b|\n", ethnicities)

    for category in all_words:
        formatted = category.replace(",", "")
        new_str = ""
        curr_el = formatted.split()

        for i, word in enumerate(curr_el):
            if word[0].isupper():
                new_str += f"{word} "

                if new_str.strip() != "African-American" and "-" in new_str:
                    new_list = new_str.replace("-", ",").split(",")
                    for item in new_list:
                        ethnicity_list.add(item.strip())
                    continue

                elif new_str.strip() == "African-American":
                    new_str = new_str.replace("-", " ")

            if i + 1 == len(formatted.split()) and new_str != "":
                ethnicity_list.add(new_str.strip())

    logging.info("Parsed Ethnicities: %s", ethnicity_list)
    return list(ethnicity_list)
