# https://github.com/colmap/colmap/blob/dev/docker/Dockerfile
FROM graffitytech/colmap:3.6-cuda

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 605C66F00D6C9793 \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9 \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138

RUN apt-get update -y  && \
  apt-get install -y --no-install-recommends \
  zip \
  unzip \
  wget \
  curl \
  ffmpeg \
  libsm6 \
  libxext6 \
  git-all \
  python3 \
  python3-pip

COPY --chown=jovyan:users requirements_colmap.txt requirements.txt

RUN python3 -m pip install --upgrade pip && \
  python3 -m pip install --no-cache-dir -r requirements.txt

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

EXPOSE 8888

ENV NB_PREFIX /
ENV SHELL=/bin/bash
CMD ["sh","-c", "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX} --NotebookApp.iopub_data_rate_limit=1.0e10"]
