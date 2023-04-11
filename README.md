[![Open in Codespaces](https://img.shields.io/badge/Open%20in-Codespaces-blue?logo=github)](https://github.com/nasirus/simple_index/codespaces/new)

# 💻 ❓ Simple Index

Are you looking to ask questions about your documents?

You've come to the right place!

Simple Index allows users to interact with a chatbot or get answers to specific questions using a language model. The
script
scan a specified folder containing documentation, index data and initializes a chatbot or QA system based
on the model(Simple UI available).

It is built on [the Langchain library](https://github.com/hwchase17/langchain), which is built on top of GPT-based
language models, enabling efficient and advanced natural language processing capabilities.

## Features

* Load a specified folder to use it as a local vector store, enabling search and retrieval of
  information from the folder content

* Provides a simple web-based chat UI for user interaction and testing of the chatbot

* Provides a command line for interacting

## Installation

### Docker

deploy the Simple Index using Docker:

1. Clone this repository:

   `git clone https://github.com/nasirus/simple_index.git`

   `cd simple_index`

2. Set the required environment variables:

   `cp .env.example .env`

   Edit the .env file and set the GITHUB_LINK environment variable with the GitHub repository link and OPENAI_API_KEY

   `OPENAI_API_KEY=`

   `OPENAI_API_BASE=`

   `OPENAI_API_TYPE=azure`

   NB:

    - This example uses Azure OpenAI LLM by default. If you want to use another LLM, you can set up
      any [Langchain model](https://python.langchain.com/en/latest/modules/models/llms/integrations.html)
      in [this file](https://github.com/nasirus/simple_index/blob/main/llmhelper.py#L12) .

    - `OPENAI_API_BASE` and `OPENAI_API_TYPE` are required only if you use AzureOpenAI

3. Build the Docker image:

   `docker build -t simple-index .`

4. Run the Docker container:

   `docker run -d -p 5000:5000 --name simple-index --env-file .env simple-index`

   Once the container is running, you can access the application at http://localhost:5000/.

## How to run manually

1. Clone this repository:

   `git clone https://github.com/nasirus/simple_index.git`

   `cd simple_index`

2. [Set the required environment variables:](#Docker)

3. Create a virtual environment.

   `python -m venv myvenv`

4. To activate the virtual environment, use the appropriate command for your operating system:

   . For Windows:

   myvenv\Scripts\activate.bat

   . For macOS and Linux:

   source myvenv/bin/activate

5. Install the required dependencies:

   `pip install -r requirements.txt`

6. Add file to index in `/data/local` or create new folder and set it in `--module_name` when starting server

### a - Run the Flask application (For chat UI):

`python server.py [--module_name <module_name>] [--reload <reload>]`

you can access the application at http://127.0.0.1:5000.

* --module_name: Provide the folder name inside /data folder (default=local).
* --reload: Reload the folder data if it already exists locally. This option is not required; include it only if you
  want to force the repository to reload.

Example :

`python server.py` : run with default folder scanning /data/local
`python server.py --module_name MyProject` : run with folder scanning /data/MyProject
`python server.py --module_name MyProject --reload` : run with folder scanning /data/MyProject and reload index if exist (use it if you want refresh index)

### b - Run console chat (Command line for interacting):

Simple Index provides a chatbot or a simple question-answering bot.
The script allows users to switch between two modes: chat mode for a more interactive conversation and QA mode for quick
one-time question-answering.

`python main.py [--bot_mode <mode>] [--module_name <module_name>] [--question <question>] [--reload <reload>]`

* --bot_mode: Specify the mode for the bot, either chat or qa. Defaults to chat.
* --module_name: Provide the folder name inside /data folder (default=local).
* --question: The question to be answered in 'qa' mode.
* --reload: Reload the folder data if it already exists locally. This option is not required; include it only if you
  want to force the repository to reload.

Example :

`python main.py --bot_mode chat`

`python main.py --bot_mode qa --question "What is index helper ?"`

## Usage

### Web Chat Interface

http://127.0.0.1:5000/

This chat interface is a minimal web-based UI for interacting with the Simple Index. It displays the
conversation, has an input field for user messages, and a "Send" button. The interface is styled with an external CSS
file and uses JavaScript for interaction with the Flask backend.

### Command Line

The Command Line Chat Interface provides an interactive way for users to communicate with the Simple Index module
directly from the console.

#### Features

* Two modes of operation: The chat interface offers two modes, "chat" and "qa". In "chat" mode, users can have an
  ongoing conversation with the Simple index module. In "qa" mode, users can ask a single question and receive an
  answer.

* Chat history: The chat interface maintains a history of messages and responses, allowing users to review previous
  interactions.

### Q&A Endpoint

Send a POST request to the /qa endpoint with the following JSON payload:

`curl -X POST -H "Content-Type: application/json" -d '{"question": "your_question_here"}' http://127.0.0.1:5000/qa
`

The response will include the generated answer:

`{
"result": "generated_answer_here"
}`

## Example

### Chat UI

![Chat Interface Example](/static/ChatInterfaceExample.png)

## License

This project is licensed under the MIT License. See the LICENSE file for details.