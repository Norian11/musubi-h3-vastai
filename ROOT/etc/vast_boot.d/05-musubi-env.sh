#!/bin/bash

if [[ -z "${PORTAL_CONFIG:-}" ]]; then
    export PORTAL_CONFIG="localhost:1111:11111:/:Instance Portal|localhost:7860:17860:/:Musubi H3 Dashboard|localhost:8080:18080:/:Jupyter|localhost:8080:8080:/terminals/1:Jupyter Terminal|localhost:8384:18384:/:Syncthing|localhost:6006:16006:/:Tensorboard"
fi

export WORKSPACE="${WORKSPACE:-/workspace}"
export DATA_DIRECTORY="${DATA_DIRECTORY:-/workspace}"
export TENSORBOARD_LOG_DIR="${TENSORBOARD_LOG_DIR:-/workspace}"
