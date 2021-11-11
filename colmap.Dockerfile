# https://github.com/colmap/colmap/blob/dev/docker/Dockerfile
FROM colmap/colmap:latest

RUN apt-get update -y  && \
  apt-get install python3 python3-pip unzip wget -y

COPY requirements_colmap.txt requirements_colmap.txt

RUN pip3 install --upgrade pip && \
  pip3 install -r requirements_colmap.txt

ENV NB_PREFIX /

CMD ["sh","-c", "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX} --NotebookApp.iopub_data_rate_limit=1.0e10"]