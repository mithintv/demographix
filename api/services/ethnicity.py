import logging
import os
import re
import unicodedata
from datetime import datetime

import requests
from bs4 import BeautifulSoup
from api.data.gpt import txtcomp
from api.data.model import AlsoKnownAs


def strip_accents(text):
    """Strip accents from given text."""
    logging.info("stripping accents from %s", text)
    return "".join(
        c for c in unicodedata.normalize("NFD", text) if unicodedata.category(c) != "Mn"
    )


def parse_ethnicelebs(txt):
    """Parse <strong> block in ethnicelebs.com to return ethnicity list."""

    ethnicity_list = set([])
    _, ethnicities = txt.split(":")
    all_words = re.split(r"[\,\*/\[\]]|\band\b|\bor\b|\n", ethnicities)

    for category in all_words:
        formatted = category.replace(",", "")
        new_str = ""
        curr_el = formatted.split()

        for i, word in enumerate(curr_el):
            # print(f"'{word}'")
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

            # print(f"word: '{new_str}'")

    print(f"Parsed Ethnicities: {ethnicity_list}\n")
    return list(ethnicity_list)


def ethnicelebs(given_name):
    """Given cast name, use ethnicelebs.com to return list of ethnicity data."""

    stripped = strip_accents(given_name)
    person_name = stripped.lower().replace(" ", "-").replace(".", "")
    print(f"Attempting {person_name} on ethnicelebs.com")

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
        if soup.strong != None:
            ethnicity_description = soup.strong.get_text()
            print(f"Raw text from ethnicelebs:\n{ethnicity_description}")

            return {
                "list": parse_ethnicelebs(ethnicity_description),
                "source": response.url,
            }

        else:
            print("Page was loaded but no ethnicity information on ethnicelebs.com")
            return {}

    else:
        if len(response.url) != len(url):
            print(f"Request URL: {url}")
            print(f"Response URL: {response.url}")
            print("URL length changed... request aborted...")
        if response.status_code == 404:
            print(f"Could not find {person_name} on ethnicelebs.com")
        return {}


def wikipedia(person_name, person_bday) -> dict:
    """Given cast name, use wikipedia.org to return early life prompt for PaLM."""

    url = f"https://wikipedia.org/wiki/{person_name}"
    response = requests.get(
        url,
        headers={
            "Content-Type": "text/html",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
        },
        timeout=15,
    )
    logging.info("response: %s response_url: %s", response, response.url)
    soup = BeautifulSoup(response.text, features="html.parser")

    if response.status_code != 200:
        logging.info("Wiki page doesn't exist...")
        return {}

    birthday_span = soup.find("span", class_="bday")
    if birthday_span is None:
        logging.info("Can't verify birthday... aborting...")
        return {}

    birthday_text = birthday_span.get_text()
    if birthday_text != person_bday:
        logging.info("Birthdays don't match... aborting...")
        return {}
    logging.info("Birthdays match!")

    paras = []
    wiki_text = ""
    content = soup.select("div.mw-parser-output p")
    for child in content:
        wiki_text += child.text

    logging.info(f"Wikipedia - {wiki_text}")

    verify_result = txtcomp(wiki_text)
    # verify_result = palm_completion(wiki_text, person_name)

    if verify_result.get("mentioned") is True:
        result = txtcomp(wiki_text, verify=False)
    else:
        logging.info("No race/ethnicity information on wiki...")
        return {}

    if result and result.get("ethnicity", None) is not None:
        wiki_source = {"list": result["ethnicity"], "source": response.url}
        logging.info(wiki_source)
        return wiki_source
    elif result and result.get("ethnicities", None) is not None:
        wiki_source = {"list": result["ethnicities"], "source": response.url}
        logging.info(wiki_source)
        return wiki_source
    else:
        logging.info("No luck parsing wiki...")
        return {}


def get_ethnicity(person_obj):
    """Return list of ethnicities for a given person via ethnicelebs.com and wikipedia."""

    date_format = "%Y-%m-%d"
    birthday = ""

    person_name = person_obj.name
    alt_names = person_obj.also_known_as
    if person_obj.birthday is not None:
        birthday = person_obj.birthday.strftime(date_format)

    # Try ethnicelebs.com
    results = ethnicelebs(person_name)
    if results.get("list", None) is None:
        for alt_name in alt_names:
            if type(alt_name) == AlsoKnownAs:
                results = ethnicelebs(alt_name.name)
            else:
                results = ethnicelebs(alt_name)
            if results.get("list", None) is not None:
                return results

        if os.environ.get("OPEN_AI_KEY"):
            # Try wikipedia.org
            print(f"Attempting {person_name} on wikipedia.org")
            results = wikipedia(person_name, birthday)

    return results
