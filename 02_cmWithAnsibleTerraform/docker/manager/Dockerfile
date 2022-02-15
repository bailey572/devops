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
# Install the networking tools.  These are only required for our internal testing.
RUN apt install iputils-ping net-tools -y
#RUN apt install openssh-client gcc python-dev libkrb5-dev -y
#RUN apt install python3-pip krb5-user -y
#RUN python3 -m pip install --upgrade pip 
#RUN pip install --upgrade virtualenv
#RUN pip install pywinrm[kerberos] 
#RUN pip install pywinrm
#RUN apt install ansible -y
