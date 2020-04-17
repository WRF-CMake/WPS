#!/usr/bin/env bash

# WRF-CMake (https://github.com/WRF-CMake/wps).
# Copyright 2019 M. Riechert and D. Meyer. Licensed under the MIT License.

set -ex

SCRIPTDIR=$(dirname "$0")
cd $SCRIPTDIR/../..

if [ "$(uname)" == "Darwin" ]; then

    pip install delocate
    delocate-listdeps --all --depending build/install
    delocate-path build/install
    delocate-listdeps --all --depending build/install

elif [ "$(lsb_release -i -s)" == "CentOS" ]; then

    # Assumes we're in the manylinux Docker image.
    pys=(/opt/python/cp*)
    # Use the newest Python available in the image (last item).
    py=${pys[@]:(-1)}/bin/python

    root_dir=$(pwd)
    tmp_dir=$(mktemp -d)
    cd $tmp_dir

    echo "from setuptools import setup; setup(name='main', packages=[''], package_data={'': ['*.exe', 'util/*.exe']})" > setup.py
    cp -r $root_dir/build/install/. .
    $py setup.py bdist_wheel

    # CentOS uses /usr/lib64 but some manually installed dependencies end up in /usr/lib
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib

    auditwheel repair dist/*.whl --no-update-tags
    cd wheelhouse
    unzip *.whl

    # /bin/cp as cp is aliased to 'cp -i' and would ask before overwriting
    /bin/cp *.exe $root_dir/build/install
    /bin/cp util/*.exe $root_dir/build/install/util
    /bin/cp -r main.libs $root_dir/build/install

else
    echo "Unsupported OS: $(uname)"
    exit 1
fi