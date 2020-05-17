# syntax=docker/dockerfile:experimental
FROM python:3.8.3-slim

MAINTAINER Jerven Clark Chua <jervenclark.chua@gmail.com>

# Install Apt packages
COPY ./build/pkglist /pkglist
RUN --mount=type=cache,target=/var/cache/apt apt-get update \
    && xargs apt-get -y install < /pkglist \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install PIP modules
COPY ./build/requirements.txt /requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip pip install -r /requirements.txt \
    && jupyter contrib nbextension install \
    && python -m bash_kernel.install \
    && python -m markdown_kernel.install

# Setup Jupyter Lab Extensions
COPY ./build/.jupyter /root/.jupyter
RUN --mount=type=cache,target=/usr/local/share/jupyter/lab/staging /usr/local/bin/jupyter labextension install \
    @ijmbarr/jupyterlab_spellchecker \
    @jupyterlab/git \
    @jupyterlab/toc \
    @krassowski/jupyterlab-lsp@0.8.0 \
    jupyterlab-drawio

RUN npm cache clean --force \
    && rm -rf /usr/local/share/jupyter/lab/staging

# Set container specific configs
EXPOSE 8888
WORKDIR /notebooks

CMD ["jupyter-lab", "--ip='0.0.0.0'", "--port=8888", "--no-browser", "--allow-root"]

