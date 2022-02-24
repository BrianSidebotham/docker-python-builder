FROM centos:centos7

# A CentOS 7 container with all of the pre-requisites for building Python
WORKDIR /staging

ENV PYTHONVERSION 3.9.2

# We need a later version of gcc than CentOS 7 can provide in order to build Python3.9
RUN yum install -y centos-release-scl \
    && yum clean all \
    && yum update -y \
    && yum install -y epel-release \
    && yum install -y devtoolset-9-gcc* \
    && yum install -y autoconf \
            automake \
            bzip2-devel \
            libarchive-devel \
            libffi-devel \
            libnsl2-devel \
            libuuid-devel \
            make \
            openssl11-devel \
            ncurses-devel \
            readline-devel \
            rpmdevtools \
            rpm-build \
            sqlite-devel \
            xz-devel \
            zlib-devel \
    && source /usr/bin/scl_source enable devtoolset-9 \
    && gcc --version \
    && mkdir -p build/SPECS

COPY SPECS/*.spec build/SPECS/
COPY build.sh build.sh

VOLUME [ "/build" ]

CMD [ "/staging/build.sh" ]
