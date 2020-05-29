# syntax=docker/dockerfile:experimental
FROM python:3.8.3-slim

# Define environment variables
ARG BUILD_RFC3339="1970-01-01T00:00:00Z"
ARG COMMIT="local"
ARG VERSION="dirty"
STOPSIGNAL SIGKILL

# Declare meta
LABEL org.opencontainers.image.ref.name="jervenclark/jupyterlab" \
  org.opencontainers.image.created=$BUILD_RFC3339 \
  org.opencontainers.image.authors="Jerven Clark Chua<jervenclark.chua@gmail.com>" \
  org.opencontainers.image.documentation="https://github.com/jervenclark/docker-jupyterlab/README.md" \
  org.opencontainers.image.description="Fully set up Jupyter environment" \
  org.opencontainers.image.licenses="GPLv3" \
  org.opencontainers.image.source="https://github.com/jervenclark/docker-jupyterlab" \
  org.opencontainers.image.revision=$COMMIT \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.url="https://hub.docker.com/r/jervenclark/jupyterlab/"
ENV BUILD_RFC3339 "$BUILD_RFC3339"
ENV COMMIT "$COMMIT"
ENV VERSION "$VERSION"

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

COPY ./build/nbconfig /usr/local/etc/jupyter/nbconfig

# Set container specific configs
EXPOSE 8888
WORKDIR /notebooks

CMD ["jupyter-lab", "--ip='0.0.0.0'", "--port=8888", "--no-browser", "--allow-root"]

