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
# Ansible Manager Docker image

# Ansible Client Docker image

# Run test

Run the docker run command providing:
- The name of the container to run (<code>ansible_manager</code>)
- The i flag indicating you’d like to open an interactive SSH session to - the container. The i flag does not close the SSH session even if the - container is not attached.
- The t flag allocates a pseudo-TTY which much be used to run commands interactively.
- The base image to create the container from (<code>ubuntu</code>).
 
 ```   
    docker-compose run ansible_manager -i -t ubuntu
    docker run -it docker_ansible_manager
```

```
 sudo apt install ansible
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  python3-argcomplete python3-dnspython python3-jinja2 python3-jmespath python3-kerberos python3-libcloud python3-lockfile python3-ntlm-auth python3-requests-kerberos python3-requests-ntlm python3-selinux python3-winrm
  python3-xmltodict
Suggested packages:
  cowsay sshpass python-jinja2-doc python-lockfile-doc
The following NEW packages will be installed:
  ansible python3-argcomplete python3-dnspython python3-jinja2 python3-jmespath python3-kerberos python3-libcloud python3-lockfile python3-ntlm-auth python3-requests-kerberos python3-requests-ntlm python3-selinux
  python3-winrm python3-xmltodict
0 upgraded, 14 newly installed, 0 to remove and 0 not upgraded.
Need to get 7,677 kB of archives.
After this operation, 77.7 MB of additional disk space will be used.
Do you want to continue? [Y/n] 
```
docker network ls
NETWORK ID     NAME                                    DRIVER    SCOPE
6e19991cef97   bridge                                  bridge    local
716ed3d7926e   compose-dev-env-nifty_lamport_default   bridge    local
46a0bc5b393c   docker_default                          bridge    local
b05d1a2dd641   host                                    host      local
054cc88420e2   none                                    null      local
ericbailey@CUSTOM-i9:~$ docker network create devnet