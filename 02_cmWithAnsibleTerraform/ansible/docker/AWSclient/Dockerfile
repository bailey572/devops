# Base manager off of official ubuntu v18.04 image
FROM redhat/ubi8
# Identify the maintainer of custom image
LABEL maintainer=bailey572@msn.com
# Specify zero interactions are required during installation/upgrades (uses default answers)
#ENV DEBIAN_FRONTEND=noninteractive
# Start by initiating an update of the repositorires (RUN always executes the command on the image)
RUN yum update -y
# Install the openssh-server
RUN yum install openssh-server -y 
# Install these packages for a functional ansible runs
RUN yum install python36 -y
# Copy over the configured sshd_config to allow remote root login
COPY ./client/sshd_config /etc/ssh/
# Create a directory to hold the authorized keys (i.e. public)
RUN mkdir /root/.ssh
# disable StrictHostKeyChecking to automatically add remotehost to the images known hosts
RUN echo "Host remotehost\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
# Copy key to image. CMD sets default that can be modified when container runs
COPY ./ansible_keys/ansible_id_rsa_shared.pub /root/.ssh/authorized_keys
# Expose port 22 for ssh
EXPOSE 22
# Ensure the permissions are correct
RUN chmod -R 600 /root/.ssh


#CMD [“sleep”, “infinity”]
#  Use the entrypoint to start the ssh service and bash to keep from exiting
#ENTRYPOINT ["/bin/sh", "FOREGROUND"]
#CMD ["bash",  "FOREGROUND"]
#ENTRYPOINT ["/bin/chamber", "exec", "production", "--"]
#ENTRYPOINT ["systemctl", "status", "sshd"]
ENTRYPOINT [ "sh" ]