import os
import re
import json
import openai
openai.api_key = os.environ['OPEN_AI_KEY']


def txtcomp(source, content, person):

    rawtxt = f'''Based on the following excerpt from {source}: {content} What is a semi-accurate data model that one could use to depict {person}'s approximate race and ethnicity as a json object using just a race and ethnicity key?'''

    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "system", "content": "You are a chatbot"},
            {"role": "user", "content": rawtxt},
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
        print(data)
        return data


# if __name__ == '__main__':
