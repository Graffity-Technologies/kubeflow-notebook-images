ARG UBUNTU_VERSION=22.04

FROM ubuntu:${UBUNTU_VERSION}

ARG UBUNTU_VERSION
ARG TORCH_VERSION=2.2.1
ARG CUDA_VERSION=12.1.1
ARG CMAKE_CUDA_ARCHITECTURES=70;75;80
ARG CMAKE_BUILD_TYPE=Release

SHELL ["/bin/bash", "-c"]

# Env variables
ENV DEBIAN_FRONTEND noninteractive \
    TZ=Asia/Bangkok

# Prepare directories
WORKDIR /code

# Install build dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    git \
    ninja-build \
    libopencv-dev \
    zip \
    unzip \
    wget \
    curl \
    ffmpeg \
    libsm6 \
    libxext6 \
    ssh \
    python3 \
    python3-pip \
    sudo && \
    apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone Git
RUN git clone https://github.com/pierotofy/OpenSplat.git

# Copy everything
COPY . ./

# Upgrade cmake if Ubuntu version is 20.04
RUN if [[ "$UBUNTU_VERSION" = "20.04" ]]; then \
    apt-get update && \
    apt-get install -y ca-certificates gpg wget && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null && \
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    apt-get update && \
    apt-get install kitware-archive-keyring && \
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal-rc main' | tee -a /etc/apt/sources.list.d/kitware.list >/dev/null; \
    fi

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# Install CUDA
RUN bash OpenSplat/.github/workflows/cuda/Linux.sh "ubuntu-${UBUNTU_VERSION}" ${CUDA_VERSION}

# Install libtorch
RUN wget --no-check-certificate -nv https://download.pytorch.org/libtorch/cu"${CUDA_VERSION%%.*}"$(echo $CUDA_VERSION | cut -d'.' -f2)/libtorch-cxx11-abi-shared-with-deps-${TORCH_VERSION}%2Bcu"${CUDA_VERSION%%.*}"$(echo $CUDA_VERSION | cut -d'.' -f2).zip -O libtorch.zip && \
    unzip -q libtorch.zip -d . && \
    rm ./libtorch.zip

# Configure and build \
RUN source OpenSplat/.github/workflows/cuda/Linux-env.sh cu"${CUDA_VERSION%%.*}"$(echo $CUDA_VERSION | cut -d'.' -f2) && \
    mkdir build && \
    cd build && \
    cmake .. \
    -GNinja \
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
    -DCMAKE_PREFIX_PATH=/code/libtorch \
    -DCMAKE_INSTALL_PREFIX=/code/install \
    -DCMAKE_CUDA_ARCHITECTURES="${CMAKE_CUDA_ARCHITECTURES}" \
    -DCUDA_TOOLKIT_ROOT_DIR=${CUDA_HOME} && \
    ninja

RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install --no-cache-dir -r requirements_python.txt

EXPOSE 8888

ENV NB_PREFIX /
ENV SHELL=/bin/bash

CMD ["sh","-c", "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX} --NotebookApp.iopub_data_rate_limit=1.0e10"]