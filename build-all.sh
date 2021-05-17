#!/bin/sh

scriptdir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

PYTHONVERSIONS="3.6.13 3.7.10 3.8.10 3.9.2"
OS="centos7 centos8 ubuntu18.04 ubuntu20.04 ubuntu21.04"

for os in ${OS}; do
    for pyversion in ${PYTHONVERSIONS}; do
        echo -n "Building Python ${pyversion} for ${os}..."
        start=$(date +%s)
        ${scriptdir}/build.sh ${os} ${pyversion} > ${scriptdir}/build-${os}-${pyversion}.log 2>&1
        finish=$(date +%s)
        minutes=$(( (${finish} - ${start}) / 60 ))
        if [ $? -ne 0 ]; then
            echo "FAIL"
        else
            echo "OK (In ${minutes}min)"
        fi
    done
done
