FROM python:3.8-buster

ARG WITH_TORCHVISION=1
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         ca-certificates \
         libjpeg-dev \
         libpng-dev && \
     rm -rf /var/lib/apt/lists/*


RUN curl -o ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda install -y numpy pyyaml scipy mkl mkl-include ninja cython typing && \
     /opt/conda/bin/conda clean -ya

ENV PATH /opt/conda/bin:$PATH

RUN /opt/conda/bin/conda install -c pytorch faiss-cpu=1.7.0

RUN pip install pipenv
RUN pipenv --python=/opt/conda/bin/python --site-packages

RUN mkdir /app && cd /app

RUN pip install poetry
COPY pyproject.toml /app/

WORKDIR /app

ARG YOUR_ENV
# Project initialization:
RUN poetry config virtualenvs.create false && poetry install --no-interaction --no-ansi

COPY resources /app/resources
COPY src /app/src

