# Base manager off of official ubuntu v18.04 image
FROM ubuntu:18.04
# Identify the maintainer of custom image
LABEL maintainer=bailey572@msn.com
# Specify zero interactions are required during installation/upgrades (uses default answers)
ENV DEBIAN_FRONTEND=noninteractive
# Start by initiating an update of the repositorires
RUN apt update 
# Install these packages for a functional ansible
RUN apt install software-properties-common -y
RUN add-apt-repository --yes --update ppa:ansible/ansible
RUN apt install ansible -y
# Ensure openssh-client is up to date
RUN apt install openssh-client gcc python-dev libkrb5-dev -y
# Install the openssh-server for local ansible calls to manager
RUN apt install openssh-server -y 
# Since we have an sshd we need to cofigure it, for now we will steal the client version
# Copy over the configured sshd_config to allow remote root login
COPY ./client/sshd_config /etc/ssh/
# Copy over the configured ansible_hosts file to expose the inventory
COPY ./manager/ansible_hosts /etc/ansible/hosts
# Create a directory to hold the private key 
RUN mkdir /root/.ssh
# disable StrictHostKeyChecking to automatically add remotehost to the images known hosts
RUN echo "Host remotehost\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
# Copy private key to image. CMD sets default that can be modified when container runs
COPY ./ansible_keys/ansible_id_rsa_shared.priv /root/.ssh/id_rsa
# Copy public key to image for ansible connects
COPY ./ansible_keys/ansible_id_rsa_shared.pub /root/.ssh/authorized_keys
# Expose port 22 for ssh even for local ansible runs
EXPOSE 22
# Ensure the permissions are correct
RUN chmod -R 600 /root/.ssh
#  Use the entrypoint to start the ssh service and bash to keep from exiting
ENTRYPOINT service ssh restart && bash