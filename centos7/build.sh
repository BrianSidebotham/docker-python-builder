#!/bin/bash
#set -e (Doesn't work for scl_source)

# Build Python on Centos 7

if [ ! -d /build ]; then
    mkdir -p /build
fi

cp -r /staging/build/* /build/

cd /build && mkdir -p BUILD BUILDROOT RPMS SOURCES SPECS SRPMS

source /usr/bin/scl_source enable devtoolset-9

echo "Building python ${PYTHONVERSION}"

spectool -C SOURCES --define "python_version ${PYTHONVERSION}" -g -S SPECS/python.spec
if [ $? -ne 0 ]; then
    echo "ERROR: spectool failed"
fi

rpmbuild --define "_topdir $(pwd)" --define "python_version ${PYTHONVERSION}" -ba SPECS/python.spec
if [ $? -ne 0 ]; then
    echo "ERROR: rpmbuild failed"
fi
