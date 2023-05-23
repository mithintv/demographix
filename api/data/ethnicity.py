import requests
import re
from bs4 import BeautifulSoup


def parse_ethnicelebs(txt):
    """Parse <strong> block in ethnicelebs.com to return ethnicity list."""

    ethnicity_list = set([])
    _, ethnicities = txt.split(":")
    all_words = re.split(r"[\,\*/\[\]]|\band\b|\bor\b|\n", ethnicities)
    print(all_words)

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

    print(ethnicity_list)
    return list(ethnicity_list)


def ethnicelebs(person_name):
    """Given cast name, use ethnicelebs.com to return list of ethnicity data."""

    url = f"https://ethnicelebs.com/{person_name}"
    response = requests.get(
        url,
        headers={
            "Content-Type": "text/html",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
        },
    )
    soup = BeautifulSoup(response.text, features="html.parser")

    if response.status_code == 200 and response.url == url:
        if soup.strong != None:
            ethnicity_description = soup.strong.get_text()
            print(ethnicity_description)

            return {
                list: parse_ethnicelebs(ethnicity_description),
                url: response.url
            }

        else:
            print(f"Page was loaded but no ethnicity information on ethnicelebs.com")
            return None

    else:
        if response.url != url:
            print(f"Request URL: {url}")
            print(f"Response URL: {response.url}")
            print("URL changed... request aborted...")
        if response.status_code == 404:
            print(f"Could not find {person_name} on ethnicelebs.com")
        return None


def get_ethnicity(person):
    """Return list of ethnicities for a given person."""

    # Try ethnicelebs.com
    person_name = person["name"].lower().replace(" ", "-").replace(".", "")
    results = ethnicelebs(person_name)
    if results['list'] is None:
        for alt_name in person["also_known_as"]:
            formatted_alt_name = alt_name.lower().replace(" ", "-").replace(".", "")
            print(f"Attempting {formatted_alt_name} on ethnicelebs.com")
            results = ethnicelebs(formatted_alt_name)
            if results['list'] is not None:
                return results

    # Try wikipedia.org
    

    return results
