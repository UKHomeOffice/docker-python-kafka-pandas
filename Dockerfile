FROM python:3.8-alpine

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
        curl-dev \
    && apk add --virtual .build-deps gcc g++ musl-dev git \
    && apk add --upgrade krb5-libs apk-tools

RUN apk add --update --no-cache

RUN apk -U upgrade

ENV CFLAGS="-Wno-deprecated-declarations -Wno-unreachable-code"

RUN pip install cython pandas confluent-kafka==v1.5.0

# https://arrow.apache.org/docs/developers/cpp/building.html?highlight=snappy
RUN git clone --depth 1 --branch apache-arrow-5.0.0 https://github.com/apache/arrow.git

RUN mkdir /arrow/cpp/build
WORKDIR /arrow/cpp/build

ENV ARROW_BUILD_TYPE=release
ENV ARROW_HOME=/usr/local
ENV PARQUET_HOME=/usr/local

# disable backtrace
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
RUN rm -rf /arrow/cpp/build/thrift_ep-prefix/src/thrift_ep/lib/js/package-lock.json
RUN rm -rf /arrow/cpp/build/thrift_ep-prefix/src/thrift_ep/lib/ts/package-lock.json
RUN rm -rf /arrow/cpp/build/thrift_ep-prefix/src/thrift_ep/tutorial/go/server.key:1
RUN rm -rf /arrow/js/yarn.lock
RUN rm -rf /usr/lib/rustlib/rustc-src/rust/Cargo.lock
RUN rm -rf /usr/lib/rustlib/rustc-src/rust/compiler/rustc_codegen_cranelift/Cargo.lock
RUN rm -rf /usr/lib/rustlib/rustc-src/rust/compiler/rustc_codegen_cranelift/build_sysroot/Cargo.lock

RUN mv /arrow/python/pyarrow /usr/local/lib/python3.8/site-packages/pyarrow
