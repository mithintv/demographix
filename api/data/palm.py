import os
import json
import re
import pprint
import google.generativeai as palm


palm.configure(api_key=os.environ['PALM_API_KEY'])
models = [m for m in palm.list_models() if 'generateText' in m.supported_generation_methods]
model = models[0].name
print(f"Using {model}...")


def palm_completion(person, movie_name):
  prompt = f"""List all of the ethnicities and the source of the information of actor/actress {person} who starred in {movie_name} in JSON"""
  completion = palm.generate_text(
    model=model,
    prompt=prompt,
    temperature=0,
    # The maximum length of the response
    max_output_tokens=800)

  match = re.search(r'\{(.|\n)*\}', completion.result)
  if match:
    result = match.group()
    print(result)
  return result
  # return completion.result
