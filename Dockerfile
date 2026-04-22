FROM python:3.10-alpine3.22

# 1. System Dependencies
# Optimized to include everything needed for C-extensions and security patches
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
        linux-headers \
        libcrypto3 \
        libexpat \
        libssl3 \
        zlib \
        zlib-dev

# 2. Upgrade Core Build Tools
# We install Cython here so it is available to all child images
RUN pip install --no-cache-dir --upgrade \
    pip>=26.0.1 \
    wheel>=0.46.2 \
    setuptools>=75.0 \
    Cython==0.29.37 

# 3. Install Foundational Data Science Libraries
# Use --no-build-isolation to ensure they use the Cython/Setuptools we just installed
RUN pip install --no-cache-dir --no-build-isolation \
    "pandas>=2.2.0" \
    "numpy==1.24.2" \
    "confluent-kafka==1.5.0" \
    "pyarrow==20.0.0" \
    "urllib3>=2.6.0"

# 4. Fix the Pathing for pytest and other binaries
# This ensures that when you run 'pytest' in Drone, it finds the binary in /usr/local/bin
ENV PATH="/usr/local/bin:${PATH}"
ENV PYTHONPATH="/usr/local/lib/python3.10/site-packages"

# Set default workdir
WORKDIR /app