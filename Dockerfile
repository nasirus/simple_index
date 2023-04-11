# Use the official Python base image
FROM python:3.10

# Set the working directory
WORKDIR /app

# Update the Debian OS, install virtualenv, and clean up the apt cache
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install virtualenv

# Create a virtual environment and activate it
RUN virtualenv venv
ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Copy the requirements file into the container
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install detectron2, used to read JPG file
RUN pip install --no-cache-dir 'git+https://github.com/facebookresearch/detectron2.git'

# Copy the rest of the application into the container
COPY . .

# Make port 5000 available to the world outside this container
EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--timeout", "0", "server:app"]