# compose-ansible-env

Instead of locally installing ansible for test and evaluation, the below will capture the steps I took to easily setup and interact with an ansible environment as a series of docker containers.

# Environment Setup

  - OS: Ubuntu Linux version 20
  - Architecture: x86_64
  - Dependencies:
  -- Docker: version 20
  -- Docker Compose: version 2.2

# Docker Compose Setup
    version: "1.0"
    services:
    ansible_server:
        build: 
        context: '.'
        dockerfile: "./server/Dockerfile"
        secrets:
        - ssh_keys
        expose: 
        - 22
    ansible_client:
        build: 
        context: '.'
        dockerfile: "./client/Dockerfile"
        secrets:
        - ssh_keys
        expose: 
        - 22
    secrets:
    ssh_keys:
        file: ~/.ssh/id_rsa_shared
# Ansible Server Docker image

# Ansible Client Docker image

# Run test

Run the docker run command providing:
- The name of the container to run (<code>ansible_server</code>)
- The i flag indicating you’d like to open an interactive SSH session to - the container. The i flag does not close the SSH session even if the - container is not attached.
- The t flag allocates a pseudo-TTY which much be used to run commands interactively.
- The base image to create the container from (<code>ubuntu</code>).
 
 ```   
    docker-compose run ansible_server -i -t ubuntu
    docker run -it docker_ansible_server
```
