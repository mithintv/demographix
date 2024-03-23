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
    prompt = f"""Based on the following information: "{article}", return a JSON object with a list under a key called "ethnicity" that lists all of the ethnicities of this person. Do not provide anything that is not in JSON."""
    if verify:
        prompt = f"""Based on the following text: {article}, return a boolean JSON object with the key "mentioned" that states whether there is any mention of race, ethnicity, heritage or background in the text. Do not provide anything that is not in JSON."""

    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
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
