# Setup Test System

## Compose Ansible Environment

Instead of locally installing ansible for test and evaluation, the below will capture the steps I took to easily setup and interact with an ansible environment as a series of docker containers.

### Environment Setup Target

- OS: Ubuntu Linux version 20
- Architecture: x86_64
- Dependencies:
  - Docker: version 20
  - Docker Compose: version 2.2

### Docker Compose Setup
    version: "1.0"
    services:
    ansible_manager:
        build: 
        context: '.'
        dockerfile: "./manager/Dockerfile"
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

### Ansible Manager Docker image
ERIC - BEAT YOUR DOCKERFILE AGAINST NATIVE INSTALL

### Ansible Client Docker image

### Run test

Run the docker run command providing:
- The name of the container to run (<code>ansible_manager</code>)
- The i flag indicating you’d like to open an interactive SSH session to - the container. The i flag does not close the SSH session even if the - container is not attached.
- The t flag allocates a pseudo-TTY which much be used to run commands interactively.
- The base image to create the container from (<code>ubuntu</code>).
 
 ```   
    docker-compose run ansible_manager -i -t ubuntu
    docker run -it docker_ansible_manager
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