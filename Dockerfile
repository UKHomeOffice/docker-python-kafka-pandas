FROM python:3.9-alpine3.22
RUN apk add --update --no-cache && apk update && apk -U upgrade
# Combine apk commands for efficiency + latest security patches
RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache \
        cmake \
        build-base \
        bash \
        gcc \
        g++ \
        musl-dev \
        git \
        libffi-dev \
        librdkafka-dev \
        python3-dev \
        openssl-dev \
        linux-headers
RUN pip install --no-cache-dir --upgrade \
    pip>=26.0.1 \
    "wheel>=0.46.2" \
    "setuptools>=75.0" \
    "jaraco.context>=6.1.0" \
    "urllib3>=2.6.0"
# Avoid pinning pip/wheel too low unless required for a specific CVE — modern ones are better
RUN pip install --no-cache-dir \
    "pandas>=2.2.0" \
    cython==0.29.37 \
    numpy==1.24.2 \
    "confluent-kafka==1.5.0" \
    pyarrow==20.0.0