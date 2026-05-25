import json
import os

from api.services.logging_service import get_logger
from google import genai

logger = get_logger(__name__)

GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY")
if GEMINI_API_KEY is None:
    raise Exception("GEMINI_API_KEY is required!")


def get_json_ethnitiy_list(article: str):
    """Extract a JSON list of ethnicities from an article using the Gemini 3.5 Flash model.

    Args:
        article: The article text to analyze for ethnicity information.

    Returns:
        A JSON string containing an "ethnicities" key with a list of ethnicities found in the article.
    """
    client = genai.Client(api_key=GEMINI_API_KEY)
    prompt = f"""For the article provided below, return a JSON object with a list under a key called "ethnicities" that lists all of the ethnicities of the person. If no ethnicities are mentioned, return null. Article starts now... {article}."""
    response = client.models.generate_content(model="gemini-3.5-flash", contents=prompt)
    logger.info("Raw response:\n%s\n", response.text)
    if response.text is None:
        return None
    text = response.text.strip()
    if text.startswith("```"):
        text = text.split("\n", 1)[1]  # remove opening ```json line
        text = text.rsplit("```", 1)[0]  # remove closing ```
        text = text.strip()
    return json.loads(text)
