import requests

from bs4 import BeautifulSoup


def ethnicelebs(person_name):
    """Given cast name, use ethnicelebs.com to return list of ethnicity data."""

    url = f"http://ethnicelebs.com/{person_name}/"
    response = requests.get(url, headers={
        'Content-Type': "text/html",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
    })

    if response.status_code == 200:
        soup = BeautifulSoup(response.text, features="html.parser")

        ethnicity_description = soup.strong.get_text()
        print(ethnicity_description)

        ethnicity_list = set([])
        _, ethnicities = ethnicity_description.split(":")
        all_words = ethnicities.replace(
            "*", ",").replace("/", ",").replace("[", ",").replace("]", ",").split(",")
        for category in all_words:
            formatted = category.replace(",", "")
            new_str = ""
            for word in formatted.split():
                if word[0].isupper():
                    new_str += f"{word} "
            new_str = new_str.rstrip()

            if new_str != 'African-American' and "-" in new_str:
                new_list = new_str.replace(
                    "-", " ").split()
                for item in new_list:
                    ethnicity_list.add(item)
            elif new_str == 'African-American':
                ethnicity_list.add(new_str.replace(
                    "-", " "))
            else:
                ethnicity_list.add(new_str.rstrip())

        print(ethnicity_list)
        return list(ethnicity_list)

    elif response.status_code == 404:
        print(f"Could not find {person_name} on ethnicelebs.com")
        return None


def get_ethnicity(person):
    """Return list of ethnicities for a given person."""

    # Try ethnicelebs.com
    person_name = person['name'].lower().replace(" ", "-")
    ethnicity_list = ethnicelebs(person_name)
    if ethnicity_list is None:
        for alt_name in person['also_known_as']:
            formatted_alt_name = alt_name.lower().replace(" ", "-")
            print(f"Attempting {formatted_alt_name} on ethnicelebs.com")
            ethnicity_list = ethnicelebs(formatted_alt_name)
            if ethnicity_list is not None:
                return ethnicity_list

    return ethnicity_list
