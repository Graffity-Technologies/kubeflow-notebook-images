# kubeflow-notebook-images

Dockerfile describe notebook images for Kubeflow

### Custom Guideline

https://github.com/kubeflow/kubeflow/tree/master/components/example-notebook-servers#custom-images

### Useful Commands

```
docker build -t graffitytech/kf-notebook-<NAME>:<TAG> -f <EXT>.Dockerfile .

docker push graffitytech/kf-notebook-<NAME>
```

Images're pushed now on [Docker Hub](https://hub.docker.com/u/graffitytech)

```
// PYTHON
docker build -t graffitytech/kf-notebook-python:3.9.16 -f python-3.9.16.Dockerfile .
docker build -t graffitytech/kf-notebook-python:3.10.10 -f python-3.10.10.Dockerfile .
docker build -t graffitytech/kf-notebook-python:3.11.2 -f python-3.11.2.Dockerfile .


// PYTORCH
docker build -t graffitytech/kf-notebook-pytorch:1.9.0-cuda10.2-cudnn7-runtime -f pytorch-1.9.0-cuda10.2-cudnn7-runtime.Dockerfile .
docker build -t graffitytech/kf-notebook-pytorch:1.9.1-cuda11.1-cudnn8-runtime -f pytorch-1.9.1-cuda11.1-cudnn8-runtime.Dockerfile .
docker build -t graffitytech/kf-notebook-pytorch:1.12.1-cuda11.3-cudnn8-runtime -f pytorch-1.12.1-cuda11.3-cudnn8-runtime.Dockerfile .
docker build -t graffitytech/kf-notebook-pytorch:2.0.0-cuda11.7-cudnn8-runtime -f pytorch-2.0.0-cuda11.7-cudnn8-runtime.Dockerfile .

// CUDA
docker build -t graffitytech/kf-notebook-cuda:12.1.0-runtime-ubuntu20.04 -f cuda-12.1.0-runtime-ubuntu20.04.Dockerfile .

// COLMAP https://github.com/colmap/colmap/blob/dev/docker/Dockerfile
docker build -t graffitytech/kf-notebook-colmap -f colmap.Dockerfile .
```

It's easy to push images with Docker Desktop
