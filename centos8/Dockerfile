FROM quay.io/centos/centos:stream8

# A CentOS 8 container with all of the pre-requisites for building Python
WORKDIR /staging

ENV PYTHONVERSION 3.9.2

RUN yum -y install dnf-plugins-core \
    && yum config-manager --set-enabled powertools \
    && yum clean all \
    && yum update -y \
    && yum install -y \
            autoconf \
            automake \
            bzip2-devel \
            gcc \
            gcc-c++ \
            glibc-devel \
            libarchive-devel \
            libffi-devel \
            libuuid-devel \
            make \
            openssl-devel \
            ncurses-devel \
            readline-devel \
            rpmdevtools \
            rpm-build \
            sqlite-devel \
            xz-devel \
            zlib-devel \
    && gcc --version \
    && mkdir -p build/SPECS

COPY SPECS/*.spec build/SPECS/
COPY build.sh build.sh

VOLUME [ "/build" ]

CMD [ "/staging/build.sh" ]
