# https://github.com/colmap/colmap/blob/dev/docker/Dockerfile
FROM graffitytech/colmap:3.8

RUN apt install -y software-properties-common
RUN apt update
RUN apt install python3 python3-pip -y

RUN apt-get update -y  && \
  apt-get install -y --no-install-recommends \
  zip \
  unzip \
  wget \
  curl \
  ffmpeg \
  libsm6 \
  libxext6 \
  git-all 

COPY requirements_colmap.txt requirements.txt

RUN pip3 --upgrade pip && \
  pip3 install --no-cache-dir -r requirements.txt

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

EXPOSE 8888

ENV NB_PREFIX /
ENV SHELL=/bin/bash

CMD ["sh","-c", "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX} --NotebookApp.iopub_data_rate_limit=1.0e10"]
