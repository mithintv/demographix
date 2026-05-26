import logging

import requests
from api.data.cast_members.cast_member_repository import CastEthnicityList
from api.services.gemini.gemini_service import get_json_ethnitiy_list
from bs4 import BeautifulSoup


def check_wikipedia(person_name: str, person_bday: str) -> CastEthnicityList | None:
    """Look up a person on Wikipedia and extract their ethnicities using Gemini.

    Fetches the person's Wikipedia page, verifies identity by matching the birthday,
    then passes the article text to Gemini to extract ethnicity information.

    Args:
        person_name: The person's name, used to construct the Wikipedia URL.
        person_bday: The person's birthday (YYYY-MM-DD) for identity verification.

    Returns:
        A dict with "list" (list of ethnicities) and "source" (Wikipedia URL),
        or None if the page doesn't exist, the birthday doesn't match, or no
        ethnicity information is found.
    """

    logging.info("Attempting %s on wikipedia.org", person_name)
    url = f"https://wikipedia.org/wiki/{person_name}"
    response = requests.get(
        url,
        headers={
            "Content-Type": "text/html",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
        },
        timeout=15,
    )
    logging.info("Response: %s response_url: %s", response, response.url)
    soup = BeautifulSoup(response.text, features="html.parser")

    if response.status_code != 200:
        logging.info("Wiki page doesn't exist...")
        return None

    birthday_span = soup.find("span", class_="bday")
    if birthday_span is None:
        logging.info("Can't verify birthday... aborting...")
        return None

    birthday_text = birthday_span.get_text()
    if birthday_text != person_bday:
        logging.info("Birthdays don't match... aborting...")
        return None

    logging.info("Birthdays match!")
    wiki_text = ""
    content = soup.select("div.mw-parser-output p")
    for child in content:
        wiki_text += child.text
    logging.info("Wikipedia Text: %s", wiki_text)

    gemeni_result = get_json_ethnitiy_list(wiki_text)
    if gemeni_result is None:
        logging.info("No race/ethnicity information on wiki...")
        return None

    if gemeni_result.get("ethnicities", None) is not None:
        wiki_source: CastEthnicityList = {
            "list": gemeni_result["ethnicities"],
            "source": response.url,
        }
        logging.info("Ethnicity List from Wikipedia: %s", wiki_source)
        return wiki_source
    logging.info("No luck parsing wikipedia...")
    return None
