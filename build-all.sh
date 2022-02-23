#!/bin/sh

scriptdir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

PYTHONVERSIONS="3.8.12 3.9.10 3.10.2"
OS="ubuntu20.04 ubuntu21.10 centos8 centos7"

for os in ${OS}; do
    echo "Building Python for ${os}"
    start=$(date +%s)
    for pyversion in ${PYTHONVERSIONS}; do
        echo "Building Python ${pyversion}..."
        ${scriptdir}/build.sh ${os} ${pyversion} > ${scriptdir}/build-${os}-${pyversion}.log 2>&1 &
    done
    wait
    finish=$(date +%s)
    minutes=$(( (${finish} - ${start}) / 60 ))
    echo "Complete in ${minutes} minutes"
done
