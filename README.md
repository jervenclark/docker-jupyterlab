# Jupyter Lab Docker Container

![build](https://img.shields.io/docker/cloud/build/jervenclark/jupyterlab?style=flat-square) ![automated](https://img.shields.io/docker/cloud/automated/jervenclark/jupyterlab?style=flat-square) ![size](https://img.shields.io/docker/image-size/jervenclark/jupyterlab?style=flat-square) ![code size](https://img.shields.io/github/languages/code-size/jervenclark/docker-jupyterlab?style=flat-square)

Complete Jupyter environment setup. Software versions:

- jupyter core     : 4.6.1
- jupyter-notebook : 6.0.3
- qtconsole        : 4.7.4
- ipython          : 7.14.0
- ipykernel        : 5.3.0
- jupyter client   : 5.3.4
- jupyter lab      : 1.2.6
- nbconvert        : 5.6.1
- ipywidgets       : 7.5.1
- nbformat         : 5.0.6
- traitlets        : 4.3.3

This uses experimental syntax, to build it declare a `BUILDKIT` env variable:

```sh
DOCKER_BUILDKIT=1 docker build -t jupyterlab .
```

## Usage
```sh
docker run -dit --rm  \
    --name jupyterlab \
    -v $PWD/workspace:/home/developer/workspace \
    -p 8888:8888 \
    jervenclark/jupyterlab:latest
```
