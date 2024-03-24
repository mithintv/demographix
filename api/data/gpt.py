import json
import logging
import re

# import openai
# client = openai.OpenAI(
#     # This is the default and can be omitted
#     api_key=os.environ.get("OPEN_AI_KEY"),
# )
from g4f.client import Client

client = Client()


def txtcomp(article, verify=True):
    prompt = f"""Do not provide anything that is not in JSON. Return a JSON object with a list under a key called "ethnicity" that lists all of the ethnicities of the person based on the following article: {article}."""
    if verify:
        prompt = f"""Do not provide anything that is not in JSON. Return a boolean JSON object with the key "mentioned" that states whether there is any mention of race, ethnicity, heritage, nationality, citizenship or background for the given person based on the following article: {article}."""

    try:
        response = client.chat.completions.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a chatbot"},
                {"role": "user", "content": prompt},
            ],
            response_format={"type": "json_object"},
        )

        result = ""
        for choice in response.choices:
            result += choice.message.content

        logging.info(f"OpenAI Result: {result}")

        pattern = re.compile(r"{(.*?)}", re.DOTALL)
        match = pattern.search(result)

        if match:
            block = match.group()
            data = json.loads(block)

            if not verify:
                for ethnicity in data["ethnicity"]:
                    if "-" in ethnicity:
                        data["ethnicity"].extend(ethnicity.split("-"))

            return data
        elif verify:
            txtcomp(article)
        else:
            txtcomp(article, verify=False)
    except Exception as e:
        logging.error(e)


# if __name__ == '__main__':
