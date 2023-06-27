import os
import re
import json
import openai

if os.environ.get('OPEN_AI_KEY', None):
    openai.api_key = os.environ['OPEN_AI_KEY']


def txtcomp(article, verify=True):

    prompt = f"""Based on the following information: "{article}", Return a list of all of the ethnicities of this person in a JSON object under a key called "ethnicity"."""
    if verify:
        prompt =f"""Return a boolean JSON object with key "mentioned" that states whether there is any mention of race, ethnicity, heritage or background in the following text: {article}"""

    try:
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a chatbot"},
                {"role": "user", "content": prompt},
            ]
        )

        result = ''
        for choice in response.choices:
            result += choice.message.content

        print(result)

        pattern = re.compile(r'{(.*?)}', re.DOTALL)
        match = pattern.search(result)

        if match:
            block = match.group()
            data = json.loads(block)

            if verify == False:
                for ethnicity in data['ethnicity']:
                    if "-" in ethnicity:
                        data['ethnicity'].extend(ethnicity.split("-"))

            return data
        else:
            txtcomp(article)
    except openai.error.RateLimitError:
        print("Reached rate limit... trying again...")
        txtcomp(article)



# if __name__ == '__main__':
