# Setup Test System

## Compose Ansible Environment

Instead of locally installing ansible for test and evaluation, the below will capture the steps I took to easily setup and interact with an ansible environment as a series of docker containers.

### Environment Setup Target

- OS: Ubuntu Linux version 20
- Architecture: x86_64
- Dependencies:
  - Docker: version 20
  - Docker Compose: version 2.2

### Generate ssh keys

If they do not already exist, you will need to gereneate RSA keys and then share the public portion with each node to enable login without having to supply a password.  For the docker container clients, these will be inserted through the compose file during build. 

To gerenate new keys, issue the following command.
```
ssh-keygen
```

When prompted change file name from default from id_rsa to something memorable, such as ~/.ssh/ansible_id_rsa_shared.
Note: if you choose a different name, that name will need to be updated in the compose file template below.
Provide a passphrase for extra security or leave blank.

### Docker Compose Setup

Use the below template to populate the docker-compose file.
```
# --- indicates a new YAML file, not required but a good idea
---
# Assign an internal version number for the compose as a key/value pair
version: "1.0"
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
    # define the list of secrets,denoted by - at same level, grants access to sensitive data defined by secrets on a per-service basis.
    secrets:
      - ssh_keys
    # define list of exposed ports that Compose implementations MUST expose from container.
    expose: 
      - 22
  ansible_client:
  # Define the build section to define how to create the client docker image
    build: 
      # Define relative path starting location
      context: '.'
      # Set location of Dockerfile for image build
      dockerfile: "./client/Dockerfile"
    # define the list of secrets,denoted by - at same level, grants access to sensitive data defined by secrets on a per-service basis.
    secrets:
      - ssh_keys
    # define list of exposed ports that Compose implementations MUST expose from container.
    expose: 
      - 22
# Secrets section of the compose file to define rsa share form local system
secrets:
  # Define key value pair services can reference
  ssh_keys:
    file: ~/.ssh/ansible_id_rsa_shared
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
```
#### Test build of the Ansible Manager Image
Execute the build step through docker compose with the following command
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
- The --name flag to specify the name of the container
- The name of the container to run (<code>ansible_manager</code>)
- The i flag indicating you’d like to open an interactive SSH session to - the container. The i flag does not close the SSH session even if the - container is not attached.
- The t flag allocates a pseudo-TTY which much be used to run commands interactively.
- The base image to create the container from (<code>docker_ansible_manager</code>).
 
```       
docker run --rm --name ansible_manger -it docker_ansible_manager
```
Success will provide a root level command prompt where you can verify the existence of ansible by issueing the following command.
```
ansible --version
```
Type exit and press enter to return to your native shell and continue.

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
# Start by initiating an update of the repositorires
RUN apt update 
# Update the openssh-client
RUN apt install openssh-client -y 
```
#### Test build of the Ansible Client Image
Execute the build step through docker compose with the following command
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
- The --name flag to specify the name of the container
- The name of the container to run (<code>ansible_node</code>)
- The i flag indicating you’d like to open an interactive SSH session to - the container. The i flag does not close the SSH session even if the - container is not attached.
- The t flag allocates a pseudo-TTY which much be used to run commands interactively.
- The base image to create the container from (<code>docker_ansible_client</code>).
 
```       
docker run --rm --name ansible_node -it docker_ansible_client
```
Success will provide a root level command prompt where you can verify the containers hostname by issueing the following command.
```
hostname
```
Do NOT exit the node container at this time.

## Test the connection between the Manger and Node
Open and new terminal window and issue the following command to initiate the manager node
```
docker run --rm --name ansible_manger -it docker_ansible_manager
This is where I stopped still need to service ssh start on client and determine access pwd
```
From the manager command line, test password less ssh from the manager to the node through ssh by providing:
- the nodes host name
```
ssh HOSTNAME
```

Type exit and press enter to return to your native shell and continue.






### Run test

Run the docker run command providing:
- The name of the container to run (<code>ansible_manager</code>)
- The i flag indicating you’d like to open an interactive SSH session to - the container. The i flag does not close the SSH session even if the - container is not attached.
- The t flag allocates a pseudo-TTY which much be used to run commands interactively.
- The base image to create the container from (<code>ubuntu</code>).
 
 ```   
    docker-compose run ansible_manager -i -t ubuntu
    docker run --rm --name ansible_manger -it docker_ansible_manager
```


## Setup Docker Network

Take a quick peek to see what networks you currently have.

```
docker network ls
NETWORK ID     NAME                                    DRIVER    SCOPE
6e19991cef97   bridge                                  bridge    local
716ed3d7926e   compose-dev-env-nifty_lamport_default   bridge    local
46a0bc5b393c   docker_default                          bridge    local
b05d1a2dd641   host                                    host      local
054cc88420e2   none                                    null      local
```

Lets create one just for our ansible purpose.
```
docker network create devnet
docker network ls
docker network inspect devnet

```

### Run our containeres in the new network

```
docker run -it --rm --network devnet docker_ansible_manager /bin/bash
```