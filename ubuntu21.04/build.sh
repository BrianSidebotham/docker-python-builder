#!/bin/bash

source /etc/os-release
set -e

# Build Python on Ubuntu
scriptdir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

PYTHONMAJORMINOR=$(echo ${PYTHONVERSION} | sed "s/\([0-9]\+\)\.\([0-9]\+\)\.\([0-9]\+\)/\1\2/g")

if [ ! -d /build ]; then
    mkdir -p /build
fi

mkdir -p /build/${VERSION_ID}/${PYTHONVERSION} && cd /build/${VERSION_ID}/${PYTHONVERSION}
#cp -r /staging/build/* /build/${VERSION_ID}/${PYTHONVERSION}/

curl -o Python-${PYTHONVERSION}.tar.xz https://www.python.org/ftp/python/${PYTHONVERSION}/Python-${PYTHONVERSION}.tar.xz
tar xf Python-${PYTHONVERSION}.tar.xz
cd Python-${PYTHONVERSION}

LDFLAGS='-Wl,-rpath=\$$ORIGIN/../lib:/opt/'${PYTHONMAJORMINOR}'/lib' \
CFLAGS="" \
./configure --prefix=/opt/python${PYTHONMAJORMINOR} \
            --enable-shared \
            --enable-optimizations \
            --with-system-ffi \
            --with-ensurepip=yes \
            --enable-loadable-sqlite-extensions=yes

LDFLAGS='-Wl,-rpath=\$$ORIGIN/../lib:/opt/'${PYTHONMAJORMINOR}'/lib' \
CFLAGS="" \
make -j$(nproc --all)

LDFLAGS='-Wl,-rpath=\$$ORIGIN/../lib:/opt/'${PYTHONMAJORMINOR}'/lib' \
CFLAGS="" \
make -j$(nproc --all) DESTDIR=/build/${VERSION_ID}/${PYTHONVERSION}/install install

mkdir -p /build/${VERSION_ID}/${PYTHONVERSION}/install/DEBIAN
cat << EOF > /build/${VERSION_ID}/${PYTHONVERSION}/install/DEBIAN/control
Package: python${PYTHONMAJORMINOR}
Version: ${PYTHONVERSION}-1
Maintainer: Brian Sidebotham
Architecture: amd64
Description: Python ${PYTHONVERSION} relocateable package
Depends: liblzma, libbz2, libsqlite3, libncurses, uuid, libreadline, libgdbm, zlib1g, libncursesw5, libssl
EOF

dpkg-deb --build /build/${VERSION_ID}/${PYTHONVERSION}/install /build/${VERSION_ID}/${PYTHONVERSION}/python${PYTHONMAJORMINOR}-ubuntu-${UBUNTU_CODENAME}_${PYTHONVERSION}-1_amd64.deb
