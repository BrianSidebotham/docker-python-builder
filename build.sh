#!/bin/bash

# Script uses the containers provided by this repository to build various flavours of Python
# The script can take two parameters which are the Python version and the OS

# usage: build.sh [OS] [PYTHONVERSION]
# e.g. build.sh centos7 3.9.2
# If you don't supply any arguments the lastest CentOS7 image will be built

scriptdir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

OS=${1:-centos7}
PYTHONVERSION=${2:-3.10.2}
CONTAINERBASE=${3:-bsidebotham/python-builder}
mkdir -p build/${OS} && cd build/${OS}

echo "Building Python ${PYTHONVERSION} for ${OS}"
docker run -e PYTHONVERSION=${PYTHONVERSION} -v $(pwd):/build ${CONTAINERBASE}:${OS}
