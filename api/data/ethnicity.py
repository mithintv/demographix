import os, requests, re, unicodedata
from datetime import datetime
from bs4 import BeautifulSoup
from data.gpt import *
from data.palm import *
from model import AlsoKnownAs


def strip_accents(text):
    return ''.join(c for c in unicodedata.normalize('NFD', text)
                  if unicodedata.category(c) != 'Mn')

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
    )
    soup = BeautifulSoup(response.text, features="html.parser")

    if response.status_code == 200 and len(response.url) == len(url):
        if soup.strong != None:
            ethnicity_description = soup.strong.get_text()
            print(f"Raw text from ethnicelebs:\n{ethnicity_description}")

            return {
                "list": parse_ethnicelebs(ethnicity_description),
                "source": response.url
            }

        else:
            print(f"Page was loaded but no ethnicity information on ethnicelebs.com")
            return {}

    else:
        if len(response.url) != len(url):
            print(f"Request URL: {url}")
            print(f"Response URL: {response.url}")
            print("URL length changed... request aborted...")
        if response.status_code == 404:
            print(f"Could not find {person_name} on ethnicelebs.com")
        return {}


def wikipedia(person_name, person_bday):
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

        # Check if if it's the correct page
        birthday_span = soup.find('span', class_='bday')
        if birthday_span == None:
            print("Can't verify birthday... aborting...")
            return {}

        birthday_text = birthday_span.get_text()
        if birthday_text != person_bday:
            print("Birthdays don't match... aborting...")
            return {}
        else:
            print("Birthdays match!")

        early_life = soup.find(id='Early_life')
        personal_life = soup.find(id='Personal_life')

        if early_life == None:
            early_life = soup.find(id='Early_life_and_education')

        if early_life == None and personal_life == None:
            print("No ethnicity information on wikipedia...")
            return {}

        paras = []
        if early_life != None:
            siblings = early_life.find_parent().find_next_siblings()
            for element in siblings:
                if element.name == 'h2':
                    break
                paras.append(element)

        if personal_life != None:
            siblings = personal_life.find_parent().find_next_siblings()
            for element in siblings:
                if element.name == 'h2':
                    break
                paras.append(element)


        wiki_text = ""
        for sentence in paras:
            wiki_text += sentence.get_text()

        print(wiki_text)

        verify_result = txtcomp(wiki_text, person_name)
        # verify_result = palm_completion(wiki_text, person_name)

        print(verify_result)

        if verify_result['mentioned'] == True:
            result = txtcomp(wiki_text, verify=False)
        else:
            print("No race/ethnicity information on wiki...")
            return {}

        if result and result.get("ethnicity", None) != None:
            wiki_source = {
                "list": result['ethnicity'],
                "source": response.url
            }
            print(wiki_source)
            return wiki_source

        elif result and result.get("ethnicities", None) != None:
            wiki_source = {
                "list": result['ethnicities'],
                "source": response.url
            }
            print(wiki_source)
            return wiki_source

        else:
            print("No luck parsing wiki...")
            return {}
    else:
        print("Wiki page doesn't exist...")
        return {}


def get_ethnicity(person_obj):
    """Return list of ethnicities for a given person."""

    date_format = '%Y-%m-%d'
    birthday = ""

    person_name = person_obj.name
    alt_names = person_obj.also_known_as
    if person_obj.birthday != None:
        birthday = person_obj.birthday.strftime(date_format)

    # Try ethnicelebs.com
    results = ethnicelebs(person_name)
    if results.get('list', None) is None:
        for alt_name in alt_names:
            if type(alt_name) == AlsoKnownAs:
                results = ethnicelebs(alt_name.name)
            else:
                results = ethnicelebs(alt_name)
            if results.get('list', None) is not None:
                return results

        if os.environ['OPEN_AI_KEY']:
            # Try wikipedia.org
            print(f"Attempting {person_name} on wikipedia.org")
            results = wikipedia(person_name, birthday)

    return results
