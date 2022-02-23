#!/bin/sh

scriptdir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

PYTHONVERSIONS="3.8.12 3.9.10 3.10.2"
OS="ubuntu20.04 ubuntu21.10 centos8 centos7"

for os in ${OS}; do
    for pyversion in ${PYTHONVERSIONS}; do
        echo -n "Building Python ${pyversion} for ${os}..."
        start=$(date +%s)
        ${scriptdir}/build.sh ${os} ${pyversion} > ${scriptdir}/build-${os}-${pyversion}.log 2>&1
        result=$?
        finish=$(date +%s)
        minutes=$(( (${finish} - ${start}) / 60 ))
        if [ ${result} -ne 0 ]; then
            echo "FAIL"
        else
            echo "OK (In ${minutes}min)"
        fi
    done
done
