FROM python:3.12-alpine3.22

# 1. System Dependencies & C/C++ Build Headers
RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache \
        cmake build-base bash gcc g++ musl-dev git \
        libffi-dev librdkafka-dev python3-dev openssl-dev \
        linux-headers libcrypto3 libexpat libssl3 zlib zlib-dev

# 2. Upgrade core build tools & Cython 3.x
# Cython 3+ is required for Python 3.12 C-API compatibility
RUN pip install --no-cache-dir --upgrade \
    "pip>=26.0.1" \
    "wheel>=0.46.2" \
    "setuptools>=75.0" \
    "Cython>=3.0.0"

# 3. Data Science & Streaming Stack
# - numpy bumped to >=1.26.0 (required for Python 3.12 support without legacy distutils)
# - confluent-kafka bumped to >=2.3.0 for Python 3.12 compatibility
RUN pip install --no-cache-dir --no-build-isolation \
    "numpy>=1.26.0" \
    "pandas>=2.2.0" \
    "confluent-kafka>=2.3.0" \
    "pyarrow>=15.0.0" \
    "urllib3>=2.6.0"

# 4. Optional: Extra dependencies requested in previous iterations
RUN pip install --no-cache-dir "jaraco.context>=6.1.0"

WORKDIR /app