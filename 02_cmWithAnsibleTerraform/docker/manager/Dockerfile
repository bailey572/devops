FROM ubuntu:18.04

LABEL maintainer=bailey572@msn.com

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update 
# This is all the packages we need, epxplicitly
RUN apt install ansible python3-argcomplete python3-dnspython python3-jinja2 python3-jmespath python3-kerberos python3-libcloud python3-lockfile python3-ntlm-auth python3-requests-kerberos python3-requests-ntlm python3-selinux python3-winrm python3-xmltodict -y
# Suggested packages
RUN apt install cowsay sshpass python-jinja2-doc python-lockfile-doc -y
RUN apt install openssh-client gcc python-dev libkrb5-dev -y
RUN apt install python3-pip krb5-user -y
RUN python3 -m pip install --upgrade pip 
RUN pip install --upgrade virtualenv
RUN pip install pywinrm[kerberos] 
RUN pip install pywinrm
#RUN apt install ansible -y
