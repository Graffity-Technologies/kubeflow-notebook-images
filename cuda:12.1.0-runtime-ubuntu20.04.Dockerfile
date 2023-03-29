FROM nvidia/cuda:12.1.0-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive \
  TZ=Asia/Bangkok

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  python3.8 \
  python3-pip \
  zip \
  unzip \
  wget \
  curl \
  ffmpeg \
  libsm6 \
  libxext6 \
  git-all

COPY --chown=jovyan:users requirements_python.txt requirements.txt

RUN python3 -m pip install --upgrade pip && \
  python3 -m pip install --no-cache-dir -r requirements.txt

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

EXPOSE 8888

ENV NB_PREFIX /
ENV SHELL=/bin/bash

CMD ["sh","-c", "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX} --NotebookApp.iopub_data_rate_limit=1.0e10"]
