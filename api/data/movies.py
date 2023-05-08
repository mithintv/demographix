import requests
import os
import json

key = os.environ['API_KEY']

search_list = ['The Power of the Dog', 'Belfast', 'Coda', 'Dune', 'King Richard', 'Licorice Pizza', 'Nightmare Alley', 'The Tragedy of Macbeth', 'West Side Story']

movie_list = []
for search in search_list:
  response = requests.get(f'https://api.themoviedb.org/3/search/movie?api_key={key}&query={search}')
  parsed = response.json()
  movie = parsed['results'][0]
  movie_list.append(movie)

with open('data.json', 'w') as file:
  json.dump(movie_list, file)
