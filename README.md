# kubeflow-notebook-images

Dockerfile describe notebook images for Kubeflow

```
docker build -t graffity/kf-notebook-<NAME>:<TAG> -f Dockerfile.<EXT> .

docker push graffity/kf-notebook-<NAME>
```

Images're pushed now on [Docker Hub](https://hub.docker.com/u/graffitytech)

```
// PYTHON
docker build -t graffitytech/kf-notebook-python:3.6.15 -f Dockerfile.python-3.6.15 .
docker build -t graffitytech/kf-notebook-python:3.7.12 -f Dockerfile.python-3.7.12 .
docker build -t graffitytech/kf-notebook-python:3.8.12 -f Dockerfile.python-3.8.12 .
docker build -t graffitytech/kf-notebook-python:3.9.7 -f Dockerfile.python-3.9.7 .


// PYTORCH
docker build -t graffitytech/kf-notebook-pytorch:1.9.0-cuda10.2-cudnn7-runtime -f Dockerfile.pytorch-1.9.0-cuda10.2-cudnn7-runtime .


// CUDA
docker build -t graffitytech/kf-notebook-cuda:11.4.2-runtime-ubuntu20.04 -f Dockerfile.cuda-11.4.2-runtime-ubuntu20.04 .

// COLMAP
docker build -t graffitytech/kf-notebook-colmap -f Dockerfile.colmap .
```

It's easy to push images with Docker Desktop
