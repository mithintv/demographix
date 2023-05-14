import requests
import os
import json

from bs4 import BeautifulSoup


def get_ethnicity(person="benedict-cumberbatch"):
    """Return list of ethnicities for a given person."""

    url = f"http://ethnicelebs.com/benedict-cumberbatch/"
    response = requests.get(url, headers={
        'Content-Type': "text/html",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
    })
    soup = BeautifulSoup(response.text, features="html.parser")
    print(soup.strong)

    ethnicity_description = soup.strong.get_text()

    _, ethnicities = ethnicity_description.split(":")
    all_words = ethnicities.replace(",", "").split()
    ethnicity_list = set([])
    for word in all_words:
        for char in word:
            if char.isupper():
                ethnicity_list.add(word)

    print(ethnicity_list)


get_ethnicity()
