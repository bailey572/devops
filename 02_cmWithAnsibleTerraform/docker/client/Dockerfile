FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Base manager off of official ubuntu v18.04 image
FROM ubuntu:18.04
# Identify the maintainer of custom image
LABEL maintainer=bailey572@msn.com
# Specify zero interactions are required during installation/upgrades (uses default answers)
ENV DEBIAN_FRONTEND=noninteractive
# Start by initiating an update of the repositorires
RUN apt update 
# Install the openssh-server
RUN apt install openssh-server -y 
# Install the networking tools.  These are only required for our internal testing.
RUN apt install iputils-ping net-tools -y

RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

