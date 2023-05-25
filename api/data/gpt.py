import os
import re
import json
import openai
openai.api_key = os.environ['OPEN_AI_KEY']


def txtcomp(article, person, verify=True):

    prompt = f"""Based on the following information: "{article}", list all of the ethnicities of actor/actress {person} in JSON"""
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
            return data
        else:
            return {}
    except openai.error.RateLimitError:
        print("Reached rate limit... trying again...")
        txtcomp(article, person)



# if __name__ == '__main__':
