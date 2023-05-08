import requests
import os
import json

key = os.environ['API_KEY']



def get_movie_ids(file_path='data.json'):
  """Return a list of movie ids from sample json file created from api call."""

  id_list = []
  with open(file_path, 'r') as file:
    data = json.load(file)
    for movie in data:
      id_list.append(movie['id'])
  return id_list


def get_credits(movie_id_list):
  """Create json file of credits for a given list of movie ids."""

  credits_list = []
  for movie_id in movie_id_list:
    url = f"https://api.themoviedb.org/3/movie/{movie_id}/credits?api_key={key}&language=en-US"
    response = requests.get(url)
    credit = response.json()
    credits_list.append(credit)

  with open('credits.json', 'w') as file:
    json.dump(credits_list, file)


def parse_credits(file_path='credits.json'):
  """For each credit, parse through top 10 cast, and return list of person ids."""

  person_ids = []
  with open(file_path, 'r') as file:
    data = json.load(file)
    for credit in data:
      for i in range(10):
        person_id = credit['cast'][i]['id']
        person_ids.append(person_id)
  return person_ids


def get_person(person_id_list):
  """Given list of person ids, return info to seed database."""

  persons = []
  for person_id in person_id_list:
    url = f"https://api.themoviedb.org/3/person/{person_id}?api_key={key}"
    response = requests.get(url)
    person = response.json()
    persons.append(person)

    with open('persons.json', 'w') as file:
      json.dump(persons, file)


# movie_ids = get_movie_ids() # get list of movie ids
# get_credits(movie_ids) # create credits.json
# person_ids = parse_credits() # get list of top 10 person ids per movie
# get_person(person_ids) # create persons.json
