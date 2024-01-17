import google.generativeai as genai
import pickle
from flask import Flask, request, jsonify
import requests
from google.cloud import firestore

cred_path = 'REDACTED'
db = firestore.Client.from_service_account_json(cred_path)
collection_name = 'users'

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

data = pickle.load(open("data.pkl", "rb"))

prompt = "You are a helpful and joyous mental therapy assistant named Aviren. Always answer as helpfully and cheerfully as possible, while being safe. Please ensure that you answer the questions as humanly as possible as if you are having a conversation.\n\nIf a question does not make any sense, or is not factually coherent, explain why instead of answering something not correct. If you don't know the answer to a question, please don't share false information.\n\n"
last_prompt = "\n\nAnswer me in one paragraph. Do not use bullet points or listing your answer, make your response is not too long."

@app.route('/generate', methods=['POST'])
def generate_content():
    history = request.json

    if "email" not in history or "question" not in history:
        return jsonify({"error": "Prompt not provided"}), 400

    email = history["email"]
    question = history["question"]

    doc = db.collection(collection_name).document(email)

    user_history = doc.get().to_dict()['userHistory']
    bot_history = doc.get().to_dict()['botHistory']

    if user_history == "":
        user_history = []
    else:
        user_history = user_history.split("<>")

    if bot_history == "":
        bot_history = []
    else:
        bot_history = bot_history.split("<>")

    for i in range(len(user_history)):
        data.append({
            "role": "user",
            "parts": [user_history[i]]
        })
        data.append({
            "role": "model",
            "parts": [bot_history[i]]
        })

    convo = model.start_chat(history=data)

    try:
        convo.send_message(prompt + question + last_prompt)
        generated_text = convo.last.text

        user_history.append(prompt + question + last_prompt)
        bot_history.append(generated_text)

        if len(user_history) > 3:
            user_history = user_history[-3:]

        if len(bot_history) > 3:
            bot_history = bot_history[-3:]

        doc.set({
            "userHistory": "<>".join(user_history),
            "botHistory": "<>".join(bot_history)
        }, merge=True)

        return generated_text
    except Exception as e:
        print(e)
        responseError = requests.post("REDACTED", headers={"Content-Type": "application/json"})
        responseError.raise_for_status()
        generated_error = responseError.text

        return generated_error