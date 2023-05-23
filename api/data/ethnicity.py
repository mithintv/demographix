import requests
import re
from bs4 import BeautifulSoup
from data.gpt import *
from data.palm import *


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

    print(f"Parsed Ethnicities: {ethnicity_list}")
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
                "list": parse_ethnicelebs(ethnicity_description),
                "source": response.url
            }

        else:
            print(f"Page was loaded but no ethnicity information on ethnicelebs.com")
            return {}

    else:
        if response.url != url:
            print(f"Request URL: {url}")
            print(f"Response URL: {response.url}")
            print("URL changed... request aborted...")
        if response.status_code == 404:
            print(f"Could not find {person_name} on ethnicelebs.com")
        return {}


def wikipedia(person_name):
    """Given cast name, use wikipedia.org to return early life prompt for PaLM."""

    url = f"https://wikipedia.org/wiki/{person_name}"
    response = requests.get(
        url,
        headers={
            "Content-Type": "text/html",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
        },
    )
    print(response, response.url)
    soup = BeautifulSoup(response.text, features="html.parser")
    if response.status_code == 200:
        early_life = soup.find(id='Early_life')
        if early_life == None:
            early_life = soup.find(id='Early_life_and_education')
        siblings = early_life.find_parent().find_next_siblings()

        paras = []
        for element in siblings:
            if element.name == 'h2':
                break
            paras.append(element)

        wiki_text = ""
        for sentence in paras:
            wiki_text += sentence.get_text()

        print(wiki_text)

        # result = gpt.txtcomp(wiki_text, person_name)
        result = palm_completion(wiki_text, person_name)
        return {
            "list": result['ethnicity'],
            "source": response.url
        }


def get_ethnicity(person_obj, person_dict=None):
    """Return list of ethnicities for a given person."""

    if person_dict:
        person_name = person_dict["name"].lower().replace(" ", "-").replace(".", "")
    else:
        person_name = person_obj.name

    # Try ethnicelebs.com
    results = ethnicelebs(person_name)
    if results.get('list', None) is None:
        if person_dict:
            for alt_name in person_dict["also_known_as"]:
                formatted_alt_name = alt_name.lower().replace(" ", "-").replace(".", "")
                print(f"Attempting {formatted_alt_name} on ethnicelebs.com")
                results = ethnicelebs(formatted_alt_name)
                if results.get('list', None) is not None:
                    return results
                else:
                    # Try wikipedia.org
                    print(f"Attempting {person_name} on wikipedia.org")
                    results = wikipedia(person_name)
                    print(results)
                    return results
    return results
