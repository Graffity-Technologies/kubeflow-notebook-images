FROM graffitytech/colmap:3.8-cuda11.7.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND noninteractive \
  TZ=Asia/Bangkok

RUN apt-get update && \ 
  apt-get install -y --no-install-recommends \
  zip \
  unzip \
  wget \
  curl \
  ffmpeg \
  libsm6 \
  libxext6 \
  git-all \
  ssh

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

RUN wget http://ceres-solver.org/ceres-solver-2.1.0.tar.gz
# CMake
RUN apt-get -y install cmake
# google-glog + gflags
RUN apt-get -y install libgoogle-glog-dev libgflags-dev
# Use ATLAS for BLAS & LAPACK
RUN apt-get -y install libatlas-base-dev
# Eigen3
RUN apt-get -y install libeigen3-dev
# SuiteSparse (optional)
RUN apt-get -y install libsuitesparse-dev
RUN apt-get -y install build-essential

RUN tar zxf ceres-solver-2.1.0.tar.gz && \
  mkdir ceres-bin && \
  cd ceres-bin && \
  cmake ../ceres-solver-2.1.0 && \
  make -j3 && \
  # make test && \
  make install

COPY requiments_lamar.txt requirements.txt

RUN apt update && \
  apt install -y software-properties-common && \
  add-apt-repository -y ppa:deadsnakes/ppa && \
  apt install python3.10 python3.10-dev python3.10-distutils -y
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
  python3 get-pip.py

RUN python3 -m pip install --upgrade pip && \
  python3 -m pip install --no-cache-dir -r requirements.txt

RUN git clone --recursive https://github.com/cvg/Hierarchical-Localization/
RUN cd Hierarchical-Localization/ && python3 -m pip install -e .


# RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# RUN unzip awscliv2.zip
# RUN ./aws/install

EXPOSE 8888

ENV NB_PREFIX /
ENV SHELL=/bin/bash

CMD ["sh","-c", "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX} --NotebookApp.iopub_data_rate_limit=1.0e10"]