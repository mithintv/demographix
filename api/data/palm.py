import json
import os
import re

import google.generativeai as palm

if os.environ.get('PALM_API_KEY', None):
    palm_api_key = os.environ['PALM_API_KEY']

    palm.configure(api_key=palm_api_key)
    models = [m for m in palm.list_models() if 'generateText' in m.supported_generation_methods]
    model = models[0].name
    print(f"Using {model}...")


def palm_completion(article, verify=True):
  prompt = f"""Based on the following information: "{article}", Return a list of all of the ethnicities of this person in a JSON object under a key called "ethnicity"."""

  if verify:
    prompt =f"""Return a boolean JSON object with key "mentioned" that states whether there is any mention of race, ethnicity, heritage or background in the following text: {article}"""

  completion = palm.generate_text(
    model=model,
    prompt=prompt,
    temperature=0,
    # The maximum length of the response
    max_output_tokens=800)

  print(completion.result)

  match = re.search(r'\{(.|\n)*\}', completion.result)
  if match:
    result = match.group()
    return json.loads(result)
  else:
    return { "ethnicity": [] }
