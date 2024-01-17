from flask import Flask, request, jsonify
import google.generativeai as genai
import requests

app = Flask(__name__)

genai.configure(api_key="REDACTED")

generation_config = {
    "temperature": 0.9,
    "top_p": 1,
    "top_k": 1,
    "max_output_tokens": 2048,
}

safety_settings = [
    {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_MEDIUM_AND_ABOVE"},
    {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_MEDIUM_AND_ABOVE"},
    {"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_MEDIUM_AND_ABOVE"},
    {"category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_MEDIUM_AND_ABOVE"},
]

model = genai.GenerativeModel(model_name="gemini-pro",
                              generation_config=generation_config,
                              safety_settings=safety_settings)

@app.route('/generate', methods=['POST'])
def generate_content():
    prompt_parts = [
      "Do not use high-level vocabularies, make it informal. Please ensure that there is an adverbial phrase in the beginning of the sentence.",
      "input: Generate me the one sentence, asking something positive about the person's daily life. Use first pov.",
      "output: On another note, what little things put a smile on your face when you wake up?",
      "input: Generate me the one sentence, asking something positive about the person's daily life. Use first pov.",
      "output: By the way, what's your go-to breakfast that sets your day on the right track?",
      "input: Generate me the one sentence, asking something positive about the person's daily life. Use first pov.",
      "output: While we're at it, how do you squeeze in moments of relaxation during a busy day?",
      "input: Generate me the one sentence, asking something positive about the person's daily life. Use first pov.",
      "output: Any recent tunes that you can't stop listening to?",
      "input: Generate me the one sentence, asking something positive about the person's daily life. Use first pov.",
      "output: As an aside, who's someone you haven't caught up with in a while that you'd love to reconnect with?",
      "input: Generate me the one sentence, asking something positive about the person's daily life. Use first pov.",
      "output: Also, What's the last thing that genuinely cracked you up online?",
      "input: Generate me the one sentence, asking something positive about the person's daily life. Use first pov.",
      "output: ",
    ]

    try:
        response = model.generate_content(prompt_parts)
        generated_text = response.text
        return generated_text

    except Exception as e:
        return jsonify({'error': str(e)}), 500