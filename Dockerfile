FROM python:3.9-alpine3.15
RUN apk add --update --no-cache && apk update && apk -U upgrade
RUN apk add cmake build-base bash gcc g++ musl-dev git libffi-dev librdkafka-dev python3-dev
RUN python -m pip install --upgrade pip setuptools wheel
RUN pip install cython==0.29.37 pandas==2.3.0 confluent-kafka==v1.5.0 pyarrow==20.0.0
