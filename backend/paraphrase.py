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
        "Do not use high-level vocabularies, make it informal",
        "input: Paraphrase this sentence.\n\nI understand what you are going through and how hard it can sometimes be. But just remember that you are not alone and life is worth living.",
        "output: I totally get that things can get crazy and overwhelming sometimes. Just want you to know, I'm here for you. Life can throw some serious curveballs, but you're not in this alone. Take a breath, you're doing better than you think.",
        "input: Paraphrase this sentence.\n\nI understand what you are going through and how hard it can sometimes be. But just remember that you are not alone and life is worth living.",
        "output: Life's rollercoaster can be quite the ride, and I acknowledge the challenges it brings. I want you to feel the comfort of my support. You're not in this alone. I'm confident there's something extraordinary waiting to be discovered by you.",
        "input: Paraphrase this sentence.\n\nI understand what you are going through and how hard it can sometimes be. But just remember that you are not alone and life is worth living.",
        "output: Life's complexities can be like a puzzle, and I understand it might feel overwhelming. I'm here, not just as a piece but as a partner in solving it with you. Remember, you're not navigating this intricate maze by yourself. Take a pause; you're navigating through it with more grace than you realize.",
        "input: Paraphrase this sentence.\n\nI understand what you are going through and how hard it can sometimes be. But just remember that you are not alone and life is worth living.",
        "output: Life's twists and turns can be dizzying, and I want you to know that I'm here as your compass in this labyrinth. You're not on this journey solo, and your resilience is guiding you through the chaos. Take a reflective moment; you're achieving more than you give yourself credit for.",
        "input: Paraphrase this sentence.\n\nI understand what you are going through and how hard it can sometimes be. But just remember that you are not alone and life is worth living.",
        "output: Navigating life is like sailing through unpredictable waters, and I recognize the storms it can bring. I'm here, not just as an observer but as your steady anchor. You're not sailing through the tempest alone; your resilience is steering the ship. The upcoming pages hold untold adventures, and I'm confident there's a captivating plot twist waiting just for you.",
        "input: Paraphrase this sentence.\n\nI understand what you are going through and how hard it can sometimes be. But just remember that you are not alone and life is worth living.",
        "output: ",
    ]
    
    try:
        response = model.generate_content(prompt_parts)
        generated_text = response.text
        return generated_text

    except Exception as e:
        return jsonify({'error': str(e)}), 500