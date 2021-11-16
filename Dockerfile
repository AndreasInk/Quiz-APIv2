# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.8

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

# Install production dependencies.

RUN apt-get update
RUN pip install --upgrade pip
RUN pip install --upgrade pip setuptools wheel
RUN pip install sentencepiece
RUN pip install setuptools_rust docker-compose
RUN pip install protobuf
RUN pip install torch
RUN pip install numpy
RUN pip install tokenizers
RUN pip install tqdm
RUN pip install filelock
RUN pip install pyyaml


RUN pip install --no-cache-dir -r requirements.txt
RUN python -m nltk.downloader punkt -d /usr/local/nltk_data
# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app