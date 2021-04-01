#!/bin/bash
set -e

# Build Python on Ubuntu 18.04
scriptdir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

PYTHONMAJORMINOR=$(echo ${PYTHONVERSION} | sed "s/\([0-9]\+\)\.\([0-9]\+\)\.\([0-9]\+\)/\1\2/g")

if [ ! -d /build ]; then
    mkdir -p /build
fi

mkdir -p /build/18.04/${PYTHONVERSION} && cd /build/18.04/${PYTHONVERSION}
#cp -r /staging/build/* /build/18.04/${PYTHONVERSION}/

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
make -j$(nproc --all) DESTDIR=/build/18.04/${PYTHONVERSION}/install install

mkdir -p /build/18.04/${PYTHONVERSION}/install/DEBIAN
cat << EOF > /build/18.04/${PYTHONVERSION}/install/DEBIAN/control
Package: python${PYTHONMAJORMINOR}
Version: ${PYTHONVERSION}-1
Maintainer: Brian Sidebotham
Architecture: amd64
Description: Python ${PYTHONVERSION} relocateable package
Depends: liblzma, libbz2, libsqlite3, libncurses, uuid, libreadline, libgdbm, zlib1g, libncursesw5, libssl
EOF

dpkg-deb --build /build/18.04/${PYTHONVERSION}/install /build/18.04/${PYTHONVERSION}/python${PYTHONMAJORMINOR}_${PYTHONVERSION}-1_amd64.deb
