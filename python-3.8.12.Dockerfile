FROM python:3.8.12-slim-buster

RUN apt-get update && \ 
  apt-get install -y --no-install-recommends \
  zip \
  unzip \
  wget 

COPY --chown=jovyan:users requirements_python.txt requirements.txt

RUN python3 -m pip install --no-cache-dir -r requirements.txt

EXPOSE 8888

ENV NB_PREFIX /

CMD ["sh","-c", "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX} --NotebookApp.iopub_data_rate_limit=1.0e10"]