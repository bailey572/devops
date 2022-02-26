# Setup Ansible Test System

## Compose Ansible Environment

Instead of locally installing ansible for test and evaluation, the below will capture the steps I took to easily setup and interact with an ansible environment as a series of docker containers.
***
***WARNING: IMAGES CREATED WITH THIS METHOD SHOULD NOT BE COMMITTED TO PUBLIC REPOSITORIES***
***

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

```bash
mkdir ansible_keys client manager
touch ./client/sshd_config
touch ./client/Dockerfile
touch ./manager/ansible_hosts
touch ./manager/Dockerfile
```

### Populate SSH daemon configuration

In order to keep life simple and have our clients accept incoming SSH requests, we will need to configure the service to do so.  Populate the previously created ./client/sshd_config file with the following content.

```bash
# Allow for password less authentication
PasswordAuthentication no
# Permit root to login
PermitRootLogin without-password
# Use public key authentication (RSA in our test case)
PubkeyAuthentication yes
# Listen on port 22 for incoming connections
Port 22
# Open up to any address (Not safe in the real world)
AddressFamily any
# Answer on any address (Again not safe in the real world)
ListenAddress 0.0.0.0
ListenAddress ::
# Allow client to pass locale environment variables
AcceptEnv LANG LC_*
# override default of no subsystems
Subsystem sftp /usr/lib/openssh/sftp-server
```

This file will be placed withing our client image through the Dockerfile in a later step.

### Populate the Ansible hosts file

Keeping with the simple rule, we will copy in a pre-populated Ansible hosts file into the manager image to manage our inventory.  Populate the previously created ./manageer/ansible_hosts file with the following content.

```bash
# This is the ansible 'hosts' file.
#
# It should live in /etc/ansible/hosts
#
#   - Comments begin with the '#' character
#   - Blank lines are ignored
#   - Groups of hosts are delimited by [header] elements
#   - You can enter hostnames or ip addresses
#   - A hostname/ip can be a member of multiple groups
#
# Because this is target to a system with an active domain name system (DNS) use host names 
# as defined in the docker-compose file since IP addresses will be automatically assigned by docker.
[foundation]
ansible_manager
ansible_client
```

### Generate ssh keys

Because we are doing a very unsafe practice of dumping keys into the images themselves, you will need to generate RSA keys.  We will then copy the private key into the Manager image and the public portion within each node to enable login without having to supply a password.
For the docker manager and client container, these will be inserted through their respective Dockerfiles during build.

To generate new keys, issue the following command.

```bash
ssh-keygen
```

When prompted change file name from the default to something memorable and store in the previously defined ansible_keys directory, si [FullyQaulifiedPathOfYourProjectDirectory]/ansible_keys/ansible_id_rsa_shared.
Provide a passphrase for extra security or leave blank.

Note: If you choose a different name, that name will need to be updated in the the Dockerfile templates below and the keys must be in the local context of the Project directory to be copied in.

For my own sanity, I appended .priv to my private key to make it apparent which was private and which was public.  Hint, Private key goes on the manager, Public goes on the clients.

### Define our network

Take a look at your current environment an see what docker networks have been defined with the following command.

```bash
docker network ls
```

For our test system, we are going to run our containers in the ansible-net.  To create this network, issue the following command.

```bash
docker network create ansible-net
```

To remove unwanted docker networks use the command.  Do not remove the bridge or host networks.

```bash
docker network rm [NETWORK ID]
```

To get more information about the newly created docker network, issued the following command.

```bash
docker network inspect ansible-net
```

### Docker Compose Setup

Use the below template to populate the docker-compose file.

```yaml
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

```yaml
# Base manager off of official ubuntu v18.04 image
FROM ubuntu:18.04
# Identify the maintainer of custom image
LABEL maintainer=bailey572@msn.com
# Specify zero interactions are required during installation/upgrades (uses default answers)
ENV DEBIAN_FRONTEND=noninteractive
# Start by initiating an update of the repositories
RUN apt update 
# Install these packages for a functional ansible
RUN apt install software-properties-common -y
RUN add-apt-repository --yes --update ppa:ansible/ansible
RUN apt install ansible -y
# Ensure openssh-client is up to date
RUN apt install openssh-client gcc python-dev libkrb5-dev -y
# Install the openssh-server for local ansible calls to manager
RUN apt install openssh-server -y 
# Since we have an sshd we need to configure it, for now we will steal the client version
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
```

#### Test build of the Ansible Manager Image

Execute the build step through docker compose with the following command.  Please note that you must be the directory that contains the docker-compose.yaml file or use the -f option to point to it.

```bash
docker-compose build ansible_manager
```

This will generate the ansible manage image with the latest tag.  Verify its existence with the following command.

```bash
docker images
```

#### Test execution of the Ansible Manager Container

Run the docker run command providing:

- The --rm flag to remove the container on exit
- The --net flag to specify the network we are going to use
- The --name flag to specify the name of the container
- The name of the container to run (```ansible_manager```)
- The i flag indicating you’d like to open an interactive SSH session to - the container. The i flag does not close the SSH session even if the - container is not attached.
- The t flag allocates a pseudo-TTY which much be used to run commands interactively.
- The base image to create the container from (```docker_ansible_manager```).

```bash
docker run --rm --net=ansible-net --name ansible_manger -it docker_ansible_manager
```

Success will provide a root level command prompt where you can verify the existence of ansible by issuing the following command.

```bas
ansible --version
```

Go ahead and leave this window open as we will be coming back to it once we have the client up and running.
Note: We will need another console opened in order to build and start the client container.

### Ansible Client Docker image

Use the below template to populate the Dockerfile for the ansible_client service.

```yaml
# Base manager off of official ubuntu v18.04 image
FROM ubuntu:18.04
# Identify the maintainer of custom image
LABEL maintainer=bailey572@msn.com
# Specify zero interactions are required during installation/upgrades (uses default answers)
ENV DEBIAN_FRONTEND=noninteractive
# Start by initiating an update of the repositories (RUN always executes the command on the image)
RUN apt update 
# Install the openssh-server
RUN apt install openssh-server -y 
# Install these packages for a functional ansible runs
RUN apt install python3 -y
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

```bash
docker-compose build ansible_client
```

This will generate the ansible client image with the latest tag.  Verify its existence with the following command.

```bash
docker images
```

#### Test execution of the Ansible Client Container

Run the docker run command providing:

- The --rm flag to remove the container on exit
- The --net flag to specify the network we are going to use
- The --name flag to specify the name of the container
- The name of the container to run (```ansible_node```)
- The i flag indicating you’d like to open an interactive SSH session to - the container. The i flag does not close the SSH session even if the - container is not attached.
- The t flag allocates a pseudo-TTY which much be used to run commands interactively.
- The base image to create the container from (```docker_ansible_client```).

```bash
docker run --rm --net=ansible-net --name ansible_node -it docker_ansible_client
```

Success will provide a root level command prompt where you can verify the containers IP address by issuing the following command.

```bash
hostname -i
```

Do NOT exit the node container at this time.

## Test the connection between the Manger and Node

Return to the open terminal window containing the running manager container and verify that you can indeed ssh into the client without having to supply an password.

```bash
ssh [IP ADDRESS of CLIENT]
or
ssh [HOSTNAME of CLIENT]
```

Both the IP address and the hostname will work due to the built in DNS capability of docker and the fact that they are both running on the same virtual network, ansible-net.
Go ahead and exit both the client and the manager instances.  Because of the earlier run commands with --rm flag, the container's will automatically be removed.

## Spinning everything up the easy way

Now that we know it all works, we can leverage the docker-compose file to spin up our containers and even apply the defined host names.  To get started, issue the following command from within the directory containing the docker-compose.yaml file.
``` docker-compose up & ```
This will bring create up both the client and the manager containers.  The ampersand (&) at the end will keep it from locking the terminal window.  You may need to press enter to return to the command prompt.

Once both containers spin up, use the docker exec command to attach to the manager instance and verify the hostname of the manager, passwordless ssh to the client, and the clients hostname with the following commands.

```bash
docker ps                                                # To get the name of the manager container
# Should be docker-ansible_manager-1 but will increment if multiple instances are running
docker exec -it docker-ansible_manager-1 /bin/bash         # -it = interactive TTY bash shell
hostname                                                   # should be ansible_manager
ssh ansible_client                                         # prompt should now be ansible_client
```

Congratulations, you now have a client and manager setup and ready to play with ansible commands.  Not only do you have a work environment, you can do no harm.  Not only can you stop or start your containers keeping all of your data, you can stop, remove (rm), and run a pristine instance.  Just don't forget to copy (cp) any files you want to keep to the local filesystem before doing so.

Exit out of the container and issue the ```docker-compose stop``` command to shutdown up the containers.  You start can issue the ```docker-compose start``` to spin them up again in the exact state you left them in.

Alternatively, if you want to start from scratch after shutting down, use ```docker-compose rm``` to remove existing containers.  On the next ```docker-compose up &``` command, new instances will be spun up with all our default settings defined in the docker files.
***
***WARNING: IMAGES CREATED WITH THIS METHOD SHOULD NOT BE COMMITTED TO PUBLIC REPOSITORIES***
***

## Running through Ansible commands

Now that we have a functional playground, lets walk through some basic commands to test it out.  We will first exercise command line options and then generate an ansible playbook.
If not already connected to the ansible_manager terminal, do so now by issuing the up and exec commands from above.

```bash
docker-compose up &
docker exec -it docker-ansible_manager-1 /bin/bash
```

### Ansible command line

Generally when using ansible to configure systems, you want to capture those activities in a playbook that can be captured in a repository but there are times when simple command line, ad hoc, interactions are desired.  The following are collection are just a sample to exercise our systems.  Please review [Introduction to ad hoc commands](https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html) for more information.

To verify our managed inventory, use the built in inventory command.

```bash
ansible-inventory --list
```

This will give a listing of all items in our inventory and the foundation group we defined.  They should be identical at this point.

To see just the known hosts use ```ansible all  --list-hosts```

Starting out, we will pass linux commands directly to the target system through the ansible service by usurping the -a (MODULE_ARGS) flag and invoking default ansible 'command' module.  

The following commands will reach out to the client node and perform simple file IO.  Since we have not automated the known_host for the containers, you will prompted to establish the authenticity of the fingerprint.  Enter yes to connect and update sources known_host file.

```bash
ansible ansible_client -a "ls -al"                      # list clients working directory content
ansible ansible_client -a "touch ansible_was_here"      # Create an empty file
ansible ansible_client -a "ls -al"                      # verify that the file is there
ansible ansible_client -a "chmod 666 ansible_was_here"  # change file permissions
ansible ansible_client -a "ls -al"                      # verify -rw-rw-rw-
```

The above operation could have also been done through Ansible file module directly from the command line.

```bash
ansible ansible_client -m ansible.builtin.file -a "path=test.txt state=touch mode=666"
ansible ansible_client -a "ls -al"
```

Most Linux commands can be passed in this way but is far from ideal.  Best practices revolve around the creation of playbooks leveraging modules.

- Playbooks are configuration files containing parameters to feed modules
- Modules are pieces of scripts for systematically performing actions

Ansible provides a large collection of modules that simplify these operations that are more portable and safer.  For example, to execute the same file IO operation as above, lets see how this would work using the 'file' module.

Before we begin, go ahead and install a text editor ```apt install nano```

From the ansible_manager node, let's create our first playbook to repeat the file creation.

```bash
nano /etc/ansible/playbook.yaml
```

and populate it with the following content

```yaml
- hosts: ansible_client
  tasks:
  - name: Creating an empty file
    file:
      path: "/root/playbookTest.txt"
      state: touch
      mode: 0666
    tags:
      - create
```

Executes our playbook and verify the results with the following commands.

```bash
ansible-playbook /etc/ansible/playbook.yaml
ansible ansible_client -a "ls -al /root"
```

To remove the newly created file, update the playbook file with the following content.

```yaml
- hosts: ansible_client
  tasks:
  - name: Creating an empty file
    file:
      path: "/root/playbookTest.txt"
      state: touch
      mode: 0666
    tags:
      - create
  # Add the following
  - name: Remove an empty file
    file:
      path: "/root/playbookTest.txt"
      state: absent
    tags:
      - delete
```

This time we are going to execute just a single task 'delete' based on the tag name.

```bash
ansible-playbook /etc/ansible/playbook.yaml --tags "delete"
ansible ansible_client -a "ls -al /root"
```

Please note, if you were to run the playbook again, without the --tag specifier, you would run both tasks sequentially.  Meaning you would create the file, set its permissions, and then immediately delete it.

Interested in all the nodes?  Issue the below command to see what ansible knows or can find out.

```bash
ansible all -m ansible.builtin.setup | less
```

That's it!! You have a fully functional Ansible playground to work with.

## Docker Clean Up

This might also be a good time to mention cleanup.

Clean up docker-compose items

```bash
docker-compose down -v --rmi all --remove-orphans
```

List any containers out there

```bash
docker ps -a -q 
```

ps -a is your friend. It lists all container identifiers, and only them in a nice list.  Although just the -a option is pretty nice too.

Remove any stray containers that may have been found.

```bash
docker rm -v $(docker ps -aq -f 'status=exited')
```

Remove any image strays

```bash
docker rm -v $(docker ps -aq -f 'status=exited')
```

A really new neat way to do the above is with

```bash
docker system prune
```

Be warned, this will remove:

- all stopped containers
- all networks not used by at least one container
- all dangling images
- all dangling build cache

p.s. all of the above steps work on native Linux and Windows WSL.
