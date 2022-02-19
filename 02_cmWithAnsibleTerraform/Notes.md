# Setup Test System

## Compose Ansible Environment

Instead of locally installing ansible for test and evaluation, the below will capture the steps I took to easily setup and interact with an ansible environment as a series of docker containers.

### Environment Setup Target

- OS: Ubuntu Linux version 20
- Architecture: x86_64
- Dependencies:
  - Docker: version 20
  - Docker Compose: version 2.2

### Create our Compose environment

To get started, we are going to create a series of directories and files to keep things in order.  To begin, create an empty directory for this project.
``` mkdir [PROJECT NAME] ```
Change directory into this directory and then go ahead and create the following layout.
```
mkdir ansible_keys client manager
touch ./client/sshd_config
touch ./client/Dockerfile
touch ./manager/Dockerfile
```

### Populate SSH daemon configuration
In order to keep life simple and have our clients accept incoming SSH requests, we will need to configure the service to do so.  Populate the previously created ./client/sshd_config file with the folliwing content.
```
# Allow for passwordless authentication
PasswordAuthentication no
# Permit root to login
PermitRootLogin without-password
# Use public key authentication (RSA in our test case)
PubkeyAuthentication yes
# Listen on port 22 for incoming connections
Port 22
# Open up to any address (Not safe in the real world)
AddressFamily any
# Answer on any address (Againg not safe in the real world)
ListenAddress 0.0.0.0
ListenAddress ::
# Allow client to pass locale environment variables
AcceptEnv LANG LC_*
# override default of no subsystems
Subsystem	sftp	/usr/lib/openssh/sftp-server
```
This file will be placed withing our client image through the Dockerfile in a later step.

### Generate ssh keys

Because we are doing a very unsafe practice of dumping keys into the images themselves, you will need to gereneate RSA keys.  We will then copy the private key into the Manager image and the public portion within each node to enable login without having to supply a password.
For the docker manager and client container, these will be inserted through their respective Dockerfiles during build.

To gerenate new keys, issue the following command.
```
ssh-keygen
```

When prompted change file name from the default to something memorable and store in the previously defined ansible_keys directory, si [FullyQaulifiedPathOfYourProjectDirectory]/ansible_keys/ansible_id_rsa_shared.
Provide a passphrase for extra security or leave blank.

Note: If you choose a different name, that name will need to be updated in the the Dockerfile templates below and the keys must be in the local context of the Project directory to be copied in.

For my own sanity, I appended .priv to my private key to make it apparant which was private and which was public.  Hint, Private key goes on the manager, Public goes on the clients.

### Define our network

Take a look at your current environment an see what docker networks have been defined with the following command.
```
docker network ls
```
For our test system, we are going to run our containers in the ansible-net.  To create this network, issue the following command.
```
docker network create ansible-net
``` 
To remove unwanted docker networks use the command.  Do not remove the bridge or host networks.
```
docker network rm [NETWORK ID]
```
To get more information about the newly created docker network, issued the following command.
```
docker network inspect ansible-net
```
### Docker Compose Setup

Use the below template to populate the docker-compose file.
```
# --- indicates a new YAML file, not required but a good idea
---
# Specify Compose file version  specification in place
version: "3.3"
# Define the dictionary of services for compose file
services:
  # Define the dictionary for the ansible_manager service
  # A Service is an abstract definition of a computing resource within an application which can be scaled/replaced independently from other components.
  ansible_manager:
    # Define the build section to define how to create the manager docker image
    build: 
      # Define relative path starting location
      context: '.'
      # Set location of Dockerfile for image build
      dockerfile: "./manager/Dockerfile"
    # define list of exposed ports that Compose implementations MUST expose from container.
    expose: 
      - 22
    networks:
      - ansible-net
    # Tell compose to keep containers running interactive and with a tty
    stdin_open: true # docker run -i (interactive)
    tty: true        # docker run -t (tty)
  ansible_client:
  # Define the build section to define how to create the client docker image
    build: 
      # Define relative path starting location
      context: '.'
      # Set location of Dockerfile for image build
      dockerfile: "./client/Dockerfile"
    # define list of exposed ports that Compose implementations MUST expose from container.
    expose: 
      - 22
    # assign to ansible network
    networks:
      - ansible-net
    # Tell compose to keep containers running interactive and with a tty
    stdin_open: true # docker run -i (interactive)
    tty: true        # docker run -t (tty)

networks:
  ansible-net:
    driver: bridge
```
Please note: there are many additional options such as
- target defines the stage to build as defined inside a multi-stage Dockerfile.
- deploy section groups these constraints and allows the platform to adjust the deployment strategy.
- blkio_config defines a set of configuration options to set block IO limits for this service.
- configs grant access to configs on a per-service basis using the per-service configs configuration. 
- depends_on expresses startup and shutdown dependencies between services.
- devices defines a list of device mappings for created containers in the form of HOST_PATH:CONTAINER_PATH[:CGROUP_PERMISSIONS].
- dns defines custom DNS servers to set on the container network interface configuration. Can be a single value or a list.
- domainname declares a custom domain name to use for the service container. MUST be a valid RFC 1123 hostname.
- entrypoint overrides the default entrypoint for the Docker image.
- env_file adds environment variables to the container based on file content.
- environment defines environment variables set in the container.

Please see  [YAML Syntax](https://github.com/compose-spec/compose-spec/blob/master/spec.md) for more information.

### Ansible Manager Docker image
Use the below template to populate the Dockerfile for the ansible_manager service.
```
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
```
#### Test build of the Ansible Manager Image
Execute the build step through docker compose with the following command.  Please note that you must be the directory that contains the docker-compose.yaml file or use the -f option to point to it.
```
docker-compose build ansible_manager
```
This will generate the ansible manage image with the latest tag.  Verify its existance with the following command.
```
docker images
```
#### Test execution of the Ansible Manager Container
Run the docker run command providing:
- The --rm flag to remove the conatiner on exit
- The --net flag to specify the network we are going to use
- The --name flag to specify the name of the container
- The name of the container to run (<code>ansible_manager</code>)
- The i flag indicating you’d like to open an interactive SSH session to - the container. The i flag does not close the SSH session even if the - container is not attached.
- The t flag allocates a pseudo-TTY which much be used to run commands interactively.
- The base image to create the container from (<code>docker_ansible_manager</code>).
 
```       
docker run --rm --net=ansible-net --name ansible_manger -it docker_ansible_manager
```
Success will provide a root level command prompt where you can verify the existence of ansible by issueing the following command.
```
ansible --version
```
Go ahead and leave this window open as we will be coming back to it once we have the client up and running.
Note: We will need another console opened in order to build and start the client container.

### Ansible Client Docker image

Use the below template to populate the Dockerfile for the ansible_client service.
```
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Base manager off of official ubuntu v18.04 image
FROM ubuntu:18.04
# Identify the maintainer of custom image
LABEL maintainer=bailey572@msn.com
# Specify zero interactions are required during installation/upgrades (uses default answers)
ENV DEBIAN_FRONTEND=noninteractive
# Start by initiating an update of the repositorires (RUN always executes the command on the image)
RUN apt update 
# Install the openssh-server
RUN apt install openssh-server -y 
# Install the networking tools.  These are only required for our internal testing.
RUN apt install iputils-ping net-tools -y
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
#  Use the entrypoint to start the ssh service and bash to keep from exiting
ENTRYPOINT service ssh restart && bash
```

#### Test build of the Ansible Client Image

From the second terminal, execute the build step through docker compose with the following command.  Again, you must be in the directory that contains the docker-compose.yaml file or use the -f option.
```
docker-compose build ansible_client
```
This will generate the ansible client image with the latest tag.  Verify its existance with the following command.
```
docker images
```
#### Test execution of the Ansible Client Container
Run the docker run command providing:
- The --rm flag to remove the conatiner on exit
- The --net flag to specify the network we are going to use
- The --name flag to specify the name of the container
- The name of the container to run (<code>ansible_node</code>)
- The i flag indicating you’d like to open an interactive SSH session to - the container. The i flag does not close the SSH session even if the - container is not attached.
- The t flag allocates a pseudo-TTY which much be used to run commands interactively.
- The base image to create the container from (<code>docker_ansible_client</code>).
 
```       
docker run --rm --net=ansible-net --name ansible_node -it docker_ansible_client
```
Success will provide a root level command prompt where you can verify the containers IP address by issueing the following command.
```
hostname -i
```
Do NOT exit the node container at this time.

## Test the connection between the Manger and Node
Return to the open terminal window containing the running manager container and verify that you can indeed ssh into the client without having to supply an password.
```
ssh [IP ADDRESS of CLIENT]
or
ssh [HOSTNAME of CLIENT]
```
Both the IP address and the hostname will work due to the built in DNS capapbilty of docker and the fact that they are both running on the same virtual network, ansible-net.
Go ahead and exit both the client and the manager instances.  Because of the earlier run commands with --rm flage, the coontainers will automatically be removed.

## Spinning everything up the easy way
Now that we know it all works, we can leverage the docker-compose file to spin up our containers and even apply the defined host names.  To get started, issue the following command from within the directory containing the docker-compose.yaml file.
``` docker-compose up ```
This will bring up both the client and the manager.  Use the exec command to attach to the manager instance and verify the hostname of the manager, passwordless ssh to the client, and the clients hostname with the following commands.
```
docker ps  # To get the name of the manager container
# Should be docker-ansible_manager-1 but will increment if multiple instances are running
docker exec -it docker-ansible_manager-1 /bin/bash         # -it = interactive TTY bash shell
hostname                                                   # should be ansible_manager
ssh ansible_client                                         # prompt should now be ansible_client
```
Congradulations, you now have a client and manager setup and ready to play with ansible commands.  Exit out of the container and issue the ``` docker-compose down ``` command to clean up the containers.