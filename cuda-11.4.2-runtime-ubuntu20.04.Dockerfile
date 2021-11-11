FROM nvidia/cuda:11.4.2-runtime-ubuntu20.04

USER root
RUN apt-get update && \
  apt-get install -y --no-install-recommends python3.8 python3-pip

USER jovyan
COPY --chown=jovyan:users requirements.txt requirements.txt

RUN python3 -m pip install --upgrade pip && \
  python3 -m pip install --no-cache-dir -r requirements.txt

ENV NB_PREFIX /

CMD ["sh","-c", "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX} --NotebookApp.iopub_data_rate_limit=1.0e10"]