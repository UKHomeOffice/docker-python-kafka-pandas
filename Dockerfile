FROM python:3.9-alpine3.22
RUN apk add --update --no-cache && apk update && apk -U upgrade
RUN apk add cmake build-base bash gcc g++ musl-dev git libffi-dev librdkafka-dev python3-dev
# RUN python -m pip install --upgrade pip setuptools wheel
RUN apk update && apk upgrade binutils libexpat
RUN pip install cython==0.29.37 numpy==1.24.2 pandas==2.0.0 confluent-kafka==v1.5.0 pyarrow==20.0.0 "pip<24.1" setuptools==78.1.1 "wheel<0.45"
