FROM python:3.8.8-alpine3.13

RUN apk add --update --no-cache \
        libffi-dev \
        openssl-dev \
        librdkafka-dev \
        ca-certificates \
        cargo \
        build-base \
        autoconf \
        cmake \
        make \
        bash \
        boost-dev \
        zlib-dev \
        flex \
        bison \
        rust \
    && apk add --virtual .build-deps gcc g++ musl-dev git

ENV CFLAGS="-Wno-deprecated-declarations -Wno-unreachable-code"

RUN pip install cython pandas confluent-kafka==v1.5.0

RUN git clone --depth 1 --branch apache-arrow-3.0.0 https://github.com/apache/arrow.git

RUN mkdir /arrow/cpp/build
WORKDIR /arrow/cpp/build

ENV ARROW_BUILD_TYPE=release
ENV ARROW_HOME=/usr/local
ENV PARQUET_HOME=/usr/local

#disable backtrace
RUN sed -i -e '/_EXECINFO_H/,/endif/d' -e '/execinfo/d' ../src/arrow/util/logging.cc

RUN cmake -DCMAKE_BUILD_TYPE=$ARROW_BUILD_TYPE \
          -DCMAKE_INSTALL_LIBDIR=lib \
          -DCMAKE_INSTALL_PREFIX=$ARROW_HOME \
          -DARROW_PARQUET=on \
          -DARROW_PYTHON=on \
          -DARROW_PLASMA=on \
          -DARROW_BUILD_TESTS=OFF \
          -DARROW_WITH_SNAPPY=ON \
          -DARROW_S3=ON \
          ..
RUN make -j$(nproc)
RUN make install

WORKDIR /arrow/python

RUN python setup.py build_ext --build-type=$ARROW_BUILD_TYPE \
       --with-parquet --inplace

RUN apk --purge del .build-deps gcc g++ musl-dev git

RUN mv /arrow/python/pyarrow /usr/local/lib/python3.8/site-packages/pyarrow
