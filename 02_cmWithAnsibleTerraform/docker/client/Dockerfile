FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
  apt install -y openssh-client && \
  apt install -y gcc python-dev libkrb5-dev && \
  apt install python3-pip -y && 