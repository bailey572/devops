# Base manager off of official ubuntu v18.04 image
FROM ubuntu:18.04
# Identify the maintainer of custom image
LABEL maintainer=bailey572@msn.com
# Specify zero interactions are required during installation/upgrades (uses default answers)
ENV DEBIAN_FRONTEND=noninteractive
# Start by initiating an update of the repositorires
RUN apt update 
# Install these packages for a functional ansible (will not depend on auto dependencies)
RUN apt install ansible python3-argcomplete python3-dnspython python3-jinja2 python3-jmespath python3-kerberos python3-libcloud python3-lockfile python3-ntlm-auth python3-requests-kerberos python3-requests-ntlm python3-selinux python3-winrm python3-xmltodict -y
# Install optional ansible packages for completeness
RUN apt install cowsay sshpass python-jinja2-doc python-lockfile-doc -y
# Ensure openssh-client is up to date
RUN apt install openssh-client gcc python-dev libkrb5-dev -y
# Create a directory to hold the private key 
RUN mkdir /root/.ssh
# disable StrictHostKeyChecking to automatically add remotehost to the images known hosts
RUN echo "Host remotehost\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
# Copy key to image. CMD sets default that can be modified when container runs
COPY ./ansible_keys/ansible_id_rsa_shared.priv /root/.ssh/id_rsa
# Ensure the permissions are correct
RUN chmod -R 600 /root/.ssh