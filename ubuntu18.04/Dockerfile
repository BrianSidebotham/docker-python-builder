FROM ubuntu:18.04

# An Ubuntu 18:04 container with all the pre-requisites for building Python
WORKDIR /staging

ENV PYTHONVERSION 3.9.2

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get -y install \
            libffi-dev \
            automake \
            curl \
            autoconf \
            build-essential \
            liblzma-dev \
            libbz2-dev \
            libsqlite3-dev \
            libncurses-dev \
            uuid-dev \
            libreadline-dev \
            libgdbm-dev \
            zlib1g-dev \
            libncursesw5-dev \
            libssl-dev \
    && mkdir /build

COPY build.sh build.sh

VOLUME [ "/build" ]

CMD [ "/staging/build.sh" ]
