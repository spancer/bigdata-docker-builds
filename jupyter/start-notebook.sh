#!/usr/bin/env bash

set -e

if [[ "$#" -ne 0 ]]; then
    exec "$@"
else
    # Start Jupyter Notebook
    jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root
fi