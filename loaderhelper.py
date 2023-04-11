import shutil
from pathlib import Path
import codecs
import logging
import os
from typing import Dict, Optional

import langchain.text_splitter
import pypdf
from langchain.document_loaders import TextLoader, NotebookLoader, UnstructuredMarkdownLoader, PyPDFLoader, \
    UnstructuredImageLoader, UnstructuredPowerPointLoader, UnstructuredWordDocumentLoader
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.vectorstores import Chroma

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')


def split_documents(documents, chunk_size=1000, chunk_overlap=0):
    text_splitter = langchain.text_splitter.RecursiveCharacterTextSplitter(chunk_size=chunk_size,
                                                                           chunk_overlap=chunk_overlap)
    return text_splitter.split_documents(documents)


def init_db(path: str,
            persist_directory: str,
            embedding: HuggingFaceEmbeddings = HuggingFaceEmbeddings()):
    logging.info("Initializing database...")
    db_local = Chroma(embedding_function=embedding, persist_directory=persist_directory)

    file_types_loaders: Dict[str, type] = {
        '.ipynb': NotebookLoader,
        '.md': UnstructuredMarkdownLoader,
        '.pdf': PyPDFLoader,
        '.txt': TextLoader,
        '.jpg': UnstructuredImageLoader,
        '.asciidoc': TextLoader,
        '.pptx': UnstructuredPowerPointLoader,
        '.docx': UnstructuredWordDocumentLoader,
    }

    def is_utf8(file_path: str) -> bool:
        try:
            with codecs.open(file_path, encoding='utf-8', errors='strict') as f:
                for _ in f:
                    pass
            return True
        except UnicodeDecodeError:
            return False

    def load_files(file_type: str, class_loader: type):
        list_files_result = list_files(path, filetype=file_type)
        logging.info(f"Found {len(list_files_result)} {file_type} files in {path}")

        for file in list_files_result:

            if file_type == '.txt':
                if not is_utf8(file):
                    logging.warning(f"Skipping non-UTF-8 file {file}")
                    continue
            if file_type == '.asciidoc':
                if not is_utf8(file):
                    logging.warning(f"Skipping non-UTF-8 file {file}")
                    continue

            if file_type == '.ipynb':
                loader = class_loader(path=file, include_outputs=False, remove_newline=True)
            elif file_type == '.txt':
                loader = class_loader(file_path=file, encoding="utf-8")
            elif file_type == '.asciidoc':
                loader = class_loader(file_path=file, encoding="utf-8")
            else:
                loader = class_loader(file)

            logging.info(f"Loading file {file}...")
            documents = loader.load()
            docs = split_documents(documents)
            if len(docs) > 0:
                db_local.add_documents(docs)

    for filetype, loader_class in file_types_loaders.items():
        load_files(filetype, loader_class)

    logging.info("Database initialized successfully.")
    return db_local


def list_files(startpath, filetype: str = '.txt'):
    txt_files = []
    for root, dirs, files in os.walk(startpath):
        for filename in files:
            # Split filename into base name and extension
            base_name, extension = os.path.splitext(filename)

            if 'LICENSE' in base_name:
                continue
            if 'NOTICE' in base_name:
                continue

            # Check if extension matches
            if extension == filetype:
                # If it's a PDF file, check if it's encrypted
                if filetype == '.pdf':
                    file_path = os.path.join(root, filename)
                    with open(file_path, 'rb') as f:
                        pdf_reader = pypdf.PdfReader(f)
                        if pdf_reader.is_encrypted:
                            continue

                txt_files.append(os.path.join(root, filename).replace('\\', '/'))
    return txt_files


def get_chroma_db(module_name: str,
                  embedding: HuggingFaceEmbeddings = HuggingFaceEmbeddings(),
                  reload: bool = False) -> Optional[Chroma]:
    data_dir = Path("data") / module_name
    db_dir = Path("db") / module_name

    if db_dir.exists() and not reload:
        logging.info(f"Module: {module_name} found, load data")
        return Chroma(persist_directory=str(db_dir), embedding_function=embedding)
    elif data_dir.exists() and (not db_dir.exists() or reload):
        if db_dir.exists():
            shutil.rmtree(db_dir)  # Use shutil.rmtree to remove the directory and its contents
        db_dir.mkdir(parents=True, exist_ok=True)  # Create the db_dir if it doesn't exist
        logging.info(f"Module: {module_name} found but not db, create index and load data")
        return init_db(path=str(data_dir), persist_directory=str(db_dir))
    else:
        logging.error("module not exist")
        return None
