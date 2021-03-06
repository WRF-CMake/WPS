#!/usr/bin/env bash

# WRF-CMake (https://github.com/WRF-CMake/wps).
# Copyright 2019 M. Riechert and D. Meyer. Licensed under the MIT License.

set -ex

# See https://docs.microsoft.com/en-gb/azure/devops/pipelines/languages/anaconda.

if [ "$(uname)" == "Darwin" ]; then
    echo "##vso[task.prependpath]$CONDA/bin"
    sudo chown -R $(id -u -n) $CONDA
elif [ "$(uname)" == "Linux" ]; then
    if [ ! -d /usr/share/miniconda ]; then
        curl -L --retry 3 https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o miniconda.sh
        chmod +x miniconda.sh
        sudo ./miniconda.sh -b -p /usr/share/miniconda
        rm miniconda.sh
    fi
    if [[ "$DOCKER" == "1" ]]; then
        echo 'export PATH=/usr/share/miniconda/bin:$PATH' >> ~/.bash_profile
    else
        echo "##vso[task.prependpath]/usr/share/miniconda/bin"
    fi
    sudo chown -R $(id -u -n) /usr/share/miniconda
else
    echo "##vso[task.prependpath]$CONDA\Scripts"
    # We don't use conda activate as we would have to repeat that in each task,
    # as Azure Pipelines does not carry over env vars from one task to the next.
    # Instead, we always use the conda base environment.
    # The following is roughly what "conda activate base" would do.
    # This is about DLL search paths and the fact that python.exe is not
    # in \Scripts but in \. On Linux/macOS things are easier.
    echo "##vso[task.prependpath]$CONDA"
    echo "##vso[task.prependpath]$CONDA\Library\mingw-w64\bin"
    echo "##vso[task.prependpath]$CONDA\Library\bin"
fi
