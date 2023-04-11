import argparse
import logging

from dotenv import load_dotenv
from flask import Flask, request
from flask import jsonify, render_template, make_response

from llmhelper import LangchainHelper

app = Flask(__name__)

load_dotenv()

logging.basicConfig(level=logging.CRITICAL, format='%(asctime)s %(levelname)s %(message)s')

parser = argparse.ArgumentParser(description="A Flask app for handling chat and QA tasks")
parser.add_argument('--module_name', type=str, default="local",
                    help='The name of the module to import and use')
parser.add_argument('--reload', action='store_true', help='Reload data')
args = parser.parse_args()
module_name = args.module_name

langchain_helper = LangchainHelper(module_name=module_name, reload=args.reload)


@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy"}), 200


@app.route('/chat', methods=['POST'])
def chat():
    data = request.get_json()
    chat_history = data.get('chat_history', [])
    query = data.get('question', '')
    result = langchain_helper.initialize_chat_bot()({"question": query, "chat_history": chat_history})
    response = {
        "answer": result["answer"],
        "chat_history": chat_history + [(query, result["answer"])]
    }
    response = make_response(jsonify({"result": response}), 200)
    return response


@app.route('/qa', methods=['POST'])
def qa():
    data = request.get_json()
    question = data.get('question', '')
    result = langchain_helper.answer_simple_question(query=question)

    response = make_response(jsonify({"result": result}), 200)
    return response


@app.route('/')
def index():
    return render_template('index.html', module_name=module_name)


if __name__ == '__main__':
    app.run(debug=False)
