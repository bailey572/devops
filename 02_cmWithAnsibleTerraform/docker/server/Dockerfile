FROM ubuntu:18.04

LABEL maintainer=bailey572@msn.com

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update 
RUN apt install openssh-client gcc python-dev libkrb5-dev -y
RUN apt install python3-pip krb5-user -y
RUN python3 -m pip install --upgrade pip 
RUN pip install --upgrade virtualenv
RUN pip install pywinrm[kerberos] 
RUN pip install pywinrm
RUN apt install ansible -y
