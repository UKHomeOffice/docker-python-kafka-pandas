FROM python:3.10-alpine3.22

# 1. System Dependencies
RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache \
        cmake build-base bash gcc g++ musl-dev git \
        libffi-dev librdkafka-dev python3-dev openssl-dev \
        linux-headers libcrypto3 libexpat libssl3 zlib zlib-dev

# 2. CRITICAL CHANGE: Downgrade Setuptools for NumPy 1.24.2 compatibility
# NumPy 1.24.x requires setuptools < 60 to find distutils during build
RUN pip install --no-cache-dir --upgrade pip>=26.0.1 wheel>=0.46.2
RUN pip install --no-cache-dir "setuptools<60.0" "Cython==0.29.37"

# 3. Install NumPy and Data Science tools
# Now NumPy 1.24.2 will find distutils and compile successfully
RUN pip install --no-cache-dir --no-build-isolation \
    "numpy==1.24.2" \
    "pandas>=2.2.0" \
    "confluent-kafka==1.5.0" \
    "pyarrow==20.0.0" \
    "urllib3>=2.6.0"

# 4. Now upgrade Setuptools back to a secure/modern version for the App
RUN pip install --no-cache-dir --upgrade "setuptools>=75.0" "jaraco.context>=6.1.0"

ENV PATH="/usr/local/bin:${PATH}"
ENV PYTHONPATH="/usr/local/lib/python3.10/site-packages"

WORKDIR /app