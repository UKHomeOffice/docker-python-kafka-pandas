FROM python:3.9.2-alpine3.13

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --update --no-cache py3-numpy py3-pandas@testing

RUN apk add --update --no-cache \
        libffi-dev \
        openssl-dev \
        librdkafka-dev \
        ca-certificates \
        cargo \
        build-base \
        cmake \
        bash \
        jemalloc-dev \
        boost-dev \
        autoconf \
        zlib-dev \
        flex \
        bison \
    && apk add --virtual .build-deps gcc g++ musl-dev rust git

RUN pip install pandas pyarrow confluent-kafka

RUN apk --purge del .build-deps gcc g++ musl-dev rust git
