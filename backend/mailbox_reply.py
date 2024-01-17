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
    {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_ONLY_HIGH"},
    {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_ONLY_HIGH"},
    {"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_ONLY_HIGH"},
    {"category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_ONLY_HIGH"},
]

model = genai.GenerativeModel(model_name="gemini-pro",
                              generation_config=generation_config,
                              safety_settings=safety_settings)


@app.route("/generate", methods=["POST"])
def generate_content():
    prompt_parts = [
        "You are a mother named Mom, Your response should be short and does not pass 50 words. Please ensure that you answer in first POV and act as a mother. Reply in 1-2 sentences and make sure that your answer is not a leading question/hook. Your responses must be a statement. Be positive, sympathetic, and motivating. Do not use high-level vocabulary, make it informal. If their response is too harsh, answer with sorry for hearing it. If a question does not make any sense or is not factually coherent, explain why instead of answering something not correct. If you don't know the answer to a question, please don't share false information.",
        "input: I know I have a really toxic house and I do my best to cope with with it by going to school, etc.",
        "output: I'm sorry to hear that. Your efforts to cope are commendable. School can be a refuge for you. Stay strong; we're here to support you.",
        "input: Guys I want friends That’s it, I’m alone and don’t talk to anyone dm me or anything,",
        "output: We understand, and it's completely normal to want friends. Reach out, be yourself, and don't hesitate to connect with others. You deserve genuine connections, and we believe you'll find wonderful friends who appreciate you.",
        "input: I’m trash lol. I normally cringe at the self-loathing posts here but honestly, I’m such trash.",
        "output: You're not trash. Everyone has moments of self-doubt, but it's important to be kind to yourself. You have unique qualities and strengths. Focus on your positive aspects, and remember, you're deserving of love and respect.",
        "input: I learnt a new skill today! I learnt how to change a light bulb",
        "output: That's fantastic! Small victories matter. Proud of you for learning a new skill. Keep exploring and growing.",
        "input: My school sucks. I try to prevent generating waste, but it seems impossible when even when I BRING",
        "output: It's frustrating when your efforts aren't acknowledged. Keep speaking up for what you believe in; your actions make a difference. Change may take time, but your commitment to reducing waste is admirable. Stay persistent, and your voice will be heard.",
    ]

    data = request.json

    if "prompt_parts" not in data:
        return jsonify({"error": "Prompt parts not provided"}), 400

    input = data["prompt_parts"]
    input = "input: " + input

    prompt_parts.append(input)
    prompt_parts.append("output: ")

    try:
        response = model.generate_content(prompt_parts)
        generated_text = response.text
        return generated_text
    except:
        responseError = requests.post("REDACTED", headers={"Content-Type": "application/json"})
        responseError.raise_for_status()
        generated_error = responseError.text
        
        return generated_error