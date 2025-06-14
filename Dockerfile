FROM python:3.9-slim
RUN apt update && apt -y upgrade
RUN apt install -y bash python3-dev
RUN pip install --upgrade pip setuptools wheel
RUN pip install cython==0.29.37 panda==1.5.3 confluent-kafka==v1.5.0
