FROM python:3.8.13-slim

RUN apt-get update

RUN apt-get upgrade -y

RUN pip install pyarrow pandas confluent-kafka==v1.5.0
