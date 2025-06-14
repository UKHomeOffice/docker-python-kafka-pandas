FROM python:3.9-slim
RUN echo 'deb http://deb.debian.org/debian testing main' >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y --no-install-recommends -o APT::Immediate-Configure=false
RUN apt update && apt -y upgrade
RUN apt install -y bash build-essential libffi-dev libssl-dev librdkafka-dev ca-certificates cargo autoconf cmake make bash libboost-all-dev zlib1g-dev flex bison curl libnghttp2-dev git librdkafka-dev libffi-dev g++ gcc python3-dev
RUN pip install --upgrade pip setuptools wheel
RUN pip install cython==0.29.37 pandas==1.5.3 confluent-kafka==v1.5.0
