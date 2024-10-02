FROM pytorch/pytorch:2.4.1-cuda12.1-cudnn9-runtime

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
    ssh \
    cmake \
    ninja-build \
    build-essential \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libeigen3-dev \
    libflann-dev \
    libfreeimage-dev \
    libmetis-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    libsqlite3-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libceres-dev

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

    # Update CMake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.30.1/cmake-3.30.1.tar.gz && \
    tar xfvz cmake-3.30.1.tar.gz && \
    cd cmake-3.30.1 && \
    ./bootstrap && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf cmake-3.30.1 cmake-3.30.1.tar.gz


# Ceres Solver
RUN wget http://ceres-solver.org/ceres-solver-2.1.0.tar.gz && \
    tar zxf ceres-solver-2.1.0.tar.gz && \
    mkdir ceres-bin && \
    cd ceres-bin && \
    cmake ../ceres-solver-2.1.0 && \
    make -j3 && \
    make install && \
    cd .. && \
    rm -rf ceres-solver-2.1.0 ceres-bin ceres-solver-2.1.0.tar.gz

# COLMAP
ARG COLMAP_VERSION=3.8
RUN git clone https://github.com/colmap/colmap.git && \
    cd colmap && \
    git checkout ${COLMAP_VERSION} && \
    mkdir build && \
    cd build && \
    cmake .. -GNinja && \
    ninja && \
    ninja install && \
    cd ../.. && \
    rm -rf colmap

COPY requiments_lamar.txt requirements.txt

RUN apt update && \
    apt install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt install python3.10 python3.10-dev python3.10-distutils -y
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py

RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install --no-cache-dir -r requirements.txt

# GLOMAP
RUN git clone https://github.com/colmap/glomap.git && \
    cd glomap && \
    mkdir build && \
    cd build && \
    cmake .. -GNinja && \
    ninja && \
    ninja install


EXPOSE 8888

ENV NB_PREFIX /
ENV SHELL=/bin/bash

CMD ["sh","-c", "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX} --NotebookApp.iopub_data_rate_limit=1.0e10"]