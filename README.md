# Jupyter Lab Docker Container

## Build

This uses experimental syntax, to build it declare a `BUILDKIT` env variable:

```sh
DOCKER_BUILDKIT=1 docker build -t jupyterlab .
```

## Usage
```sh
docker run -dv $PWD:/notebooks jervenclark/jupyterlab:latest
```
