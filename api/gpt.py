import os
import openai
openai.api_key = os.environ['OPEN_AI_KEY']


def txtcomp(rawtxt):

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

    return result


# if __name__ == '__main__':
#     rawtxt = "Ramesh and Sumit were very"
#     print(txtcomp(rawtxt))
