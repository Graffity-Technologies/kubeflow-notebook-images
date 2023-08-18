# --------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
# --------------------------------------------------------------
# Dockerfile to run ONNXRuntime with TensorRT integration

# nVidia TensorRT Base Image
ARG TRT_CONTAINER_VERSION=23.07
FROM nvcr.io/nvidia/tensorrt:${TRT_CONTAINER_VERSION}-py3

RUN --mount=type=cache,id=apt-dev,target=/var/cache/apt \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        wget \
        zip \
        ca-certificates \
        build-essential \
        curl \
        libcurl4-openssl-dev \
        libssl-dev


ARG ONNXRUNTIME_REPO=https://github.com/Microsoft/onnxruntime
ARG ONNXRUNTIME_BRANCH=main
ARG CMAKE_CUDA_ARCHITECTURES=37;50;52;60;61;70;75;80

RUN apt-get update &&\
    apt-get install -y sudo git bash unattended-upgrades
RUN unattended-upgrade

WORKDIR /code
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:/code/cmake-3.26.3-linux-x86_64/bin:/opt/miniconda/bin:${PATH}

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh --no-check-certificate && \
    /bin/bash ~/miniconda.sh -b -p /opt/miniconda &&\
    rm ~/miniconda.sh &&\
    /opt/miniconda/bin/conda clean -ya

RUN pip install --upgrade pip numpy &&\
    pip install packaging &&\
    pip install "wheel>=0.35.1" &&\
    rm -rf /opt/miniconda/pkgs

RUN wget --quiet https://github.com/Kitware/CMake/releases/download/v3.26.3/cmake-3.26.3-linux-x86_64.tar.gz &&\
    tar zxf cmake-3.26.3-linux-x86_64.tar.gz &&\
    rm -rf cmake-3.26.3-linux-x86_64.tar.gz

# Prepare onnxruntime repository & build onnxruntime with TensorRT
RUN git clone --single-branch --branch ${ONNXRUNTIME_BRANCH} --recursive ${ONNXRUNTIME_REPO} onnxruntime &&\
    trt_version=${TRT_VERSION:0:3} &&\
    /bin/sh onnxruntime/dockerfiles/scripts/checkout_submodules.sh ${trt_version} &&\
    cd onnxruntime &&\
    /bin/sh build.sh --allow_running_as_root --parallel --build_shared_lib --cuda_home /usr/local/cuda --cudnn_home /usr/lib/x86_64-linux-gnu/ --use_tensorrt --tensorrt_home /usr/lib/x86_64-linux-gnu/ --config Release --build_wheel --skip_tests --skip_submodule_sync --cmake_extra_defines '"CMAKE_CUDA_ARCHITECTURES='${CMAKE_CUDA_ARCHITECTURES}'"' &&\
    pip install /code/onnxruntime/build/Linux/Release/dist/*.whl &&\
    cd ..