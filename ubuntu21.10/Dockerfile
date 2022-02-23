FROM ubuntu:21.10

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
            libncurses-dev \
            libssl-dev \
    && apt-get clean \
    && apt-get autoremove --yes \
    && mkdir /build

COPY build.sh build.sh

VOLUME [ "/build" ]

CMD [ "/staging/build.sh" ]