## based on: https://github.com/rocker-org/ml/blob/master/tensorflow/cpu/Dockerfile

FROM rocker/tidyverse:3.6.1

ENV WORKON_HOME /opt/virtualenvs
ENV PYTHON_VENV_PATH $WORKON_HOME/r-tensorflow

## Set up python3 environment
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libpython3-dev \
        python3-venv  && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m venv ${PYTHON_VENV_PATH}

ENV PATH ${PYTHON_VENV_PATH}/bin:${PATH}

RUN pip3 install \
    h5py==2.9.0 \
    pyyaml==3.13 \
    requests==2.21.0 \
    Pillow==5.4.1 \
    tensorflow==1.12.0 \
    tensorflow-probability==0.5.0 \
    keras==2.2.4 \
    --no-cache-dir

USER root
RUN install2.r tensorflow keras caret tidyverse

ENV MODEL_DIRECTORY /home/airbnb_dl_model
RUN mkdir ${MODEL_DIRECTORY}
COPY airbnb_dl_model ${MODEL_DIRECTORY}

CMD R -e "source('${MODEL_DIRECTORY}/run_modelling.R')"
