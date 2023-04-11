import argparse
import textwrap

from colorama import init, Fore
from dotenv import load_dotenv

import llmhelper


def main(bot_mode, module_name, question, reload):
    chat_history = []

    init(autoreset=True)  # Initialize colorama

    langchain_helper = llmhelper.LangchainHelper(module_name=module_name, reload=reload)

    if bot_mode == "chat":
        chat_bot = langchain_helper.initialize_chat_bot()
        print_wrapped_text(Fore.BLUE + f"Start chat with {module_name}, type your question")

        while True:
            query = input(Fore.GREEN + "-->")
            result = chat_bot({"question": query, "chat_history": chat_history})
            chat_history.append((query, result["answer"]))
            print_wrapped_text(Fore.BLUE + "-->" + result["answer"].lstrip())
    elif bot_mode == "qa":
        result = langchain_helper.answer_simple_question(query=question)
        print_wrapped_text(Fore.BLUE + result.lstrip())


def print_wrapped_text(text, width=150):
    wrapped_text = textwrap.fill(text, width=width)
    print(wrapped_text)


if __name__ == "__main__":
    load_dotenv()
    parser = argparse.ArgumentParser(description="Chatbot and QA")
    parser.add_argument("--bot_mode", choices=["chat", "qa"], default="chat",
                        help="Choose the mode for the bot: 'chat' or 'qa'")
    parser.add_argument("--question", default="what is github helper?", help="The question to be answered in 'qa' mode")
    parser.add_argument('--reload', action='store_true', help='Reload data')
    parser.add_argument('--module_name', type=str, default="local",
                        help='The name of the module to import and use')

    args = parser.parse_args()
    main(args.bot_mode, args.module_name, args.question, args.reload)
