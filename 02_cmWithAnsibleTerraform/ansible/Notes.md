# Working with Ansible

My original intent was to work through a series of practice labs that had been assigned in a CalTech Devops class but the presentation of, and source material provided was found to be lacking.  Instead, I assembled this collection of notes based roughly on what was assigned and supplemented them with seperate research and logical groupings.

## Spin up test system

If you would like to follow along, I would suggest grabbing the docker-compose based setup to spin up a test system.  Notes for the project are located in the [Notes.md](https://github.com/bailey572/devops/blob/main/02_cmWithAnsibleTerraform/docker/Notes.md).  If you are accessing these locally from a github checkout, they are located in the root 02_cmWithAnsible/docker folder.  I highly suggest reading through them but if not, here is a quick start needed to get started.
Open a terminal folder and navigate to the 02_cmWithAnsible/docker folder and issue the following commands.

```bash
docker-compose up &
docker exec -it docker_ansible_manager_1 /bin/bash
```

The first command will create a docker network 'ansible-net', two docker images, and two docker containers 'docker_ansible_manager_1 and docker_ansible_client_1 based on those images.  

The second command will attach the current terminal to a bash console hosted on docker_ansible_manager_1 where we will be directly interacting with while most commands will be targeted to the clients through the ansible service.

## Command line

While it is always recommended to interact with ansible through the use of playbooks, it is sometimes useful to send simple commands straight from the command line and it can be useful for quick experimentation.  The following are a collection of commands with simple explanations.
For some reason, the class decided to provide command line examples over a few different labs so I have included them in here as well.

### Section 1, Lab 4 Command line runs

``` ansible foundation -m shell -a 'hostname' ```

Calls the ansible executable with the following arguments.

- foundation: group defined in the host file.  Ansible will then call each entry node sequentially and issue the command
- m: specifies to run an ansible module
- shell: module to assist in issueing shell commands
- a: shorthand for --args to pass into the module
- hostname: linux command to retrieve the name of the system

This will sequentially walk through all members of the foundation group and issue the hostname function.  For our current 'foundation' group, we have defined the ansible_client and ansible_manager systems.

Note: On first execution you will need to type yes to establish authenticity between the containers.

``` ansible ansible_client -m apt -a 'name=git state=present' ```

Calls the ansible executable with the following arguments.

- ansible_client: specific node in the host file that will be resolved through the Docker DNS capability.
- m: specifies to run an ansible module
- apt: module to assist in installing packages.  If the target was a Redhat box, would convert to native Yum command
- a: shorthand for --args to pass into the module
  - The name and the state parameter values are then passed in
  - present tells the module to install if not already present
- An optional --become runs operations with elevated (sudo) privelages but is not required here as we are executing everything as root

This command will ssh into the ansible_client machine and attempt to install the git application on the client machine after updating the repository cache and installing any missing dependencies.  If git is already present, ansible will still return a success but will report false for and changes.

``` ansible -m setup ansible_client | more ```

Calls the ansible executable with the following arguments.

- m:
- setup: module to gather facts on system/group

This is a great command and returns all the "facts" that ansible was able to gather from the client node.  Be warned, this is a lot of data which is why the output is piped to the more command for paginated output.  Hitting the space bar will allow you to scroll through the data one page at a time.  To exit, press the 'q' key.

``` ansible ansible_client -m file -a 'dest=/root/sample.txt state=touch mode=600 owner=root group=root' ```

Calls the ansible executable with the following arguments.

- ansible_client: specific node in the host file.
- m: specifies to run an ansible module
- file: module to assist in file/dir IO operations
- a: shorthand for --arge to pass into the modules
  - dest: location to place the file
  - state: set to touch to create file
  - mode: octal permissions of the file rw for user only
  - owner: set file owner as user root
  - group: set file group access to root group

This command will create an empty file on the client node  in roots home directory with rm permissions and owned by the root user and group.  

To verify its existance, issue

``` ansible ansible_client -a "ls -al /root/sample.txt" ```

Calls the ansible executable with the following arguments.

- ansible_client: specific node in the host file.
- a: shorthand for --arge to pass into the modules.  Default ansible is called
  - ls -al /root/sample.txt:

This command issues the standard linux command to do a long listing of the file /root/sample.txt returning the current permissions.

It should be noted that just about any linux command, or series of commands, can be issued in this manner but it is a bad practice.

***---Do not make it a habit----***

# First Play Book

While we could execute ansible modules directly from the command line, and there are [A LOT](https://docs.ansible.com/ansible/2.7/modules/list_of_all_modules.html) of them to choose from.  Best practices really are to issue the command through Play Books.

Play books are YAML (YAML Ain't Markup Language) scripts containing basically the same parameter arguments that we have been issueing directly from the command line.

Before we get started, lets put a simple text editor on the ansible_manager node.  From root@ansible_manager:/# issue ```apt install nano -y```

For our playbook, let's revisit the earlier command for creating an empty file on the anssible_client machine ``` ansible ansible_client -m file -a 'dest=/root/sample.txt state=touch mode=600 owner=root group=root' ```

To begin, use the nano application to create an empty file:

```bash
nano /etc/ansible/playbook.yaml
```

and populate it with the following content.  Nano is a bit nicer than VI and you should be able to simply copy and paste the data directly.

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

If everything looks ok, use the keyboard combination CTRL+o to prompt a file save and press enter to accept the default file name.  Once saved, use the keyboard combination CTRL+x to exit nano and return to the command line.

Even though it looks a bit different, you should recognize the pieces from the command line version we issued earlier but with a much nicer layout for the parameters.  Let's break it down.

```yaml
- hosts: ansible_client               # Still just calling the same system
  tasks:                              # Playbooks execute a series of plays(more on that later) that execute a series of Tasks 
  - name: Creating an empty file      # Text label for the task
    file:                             # Specifies the module to execute
      path: "/root/playbookTest.txt"  # File, or directory, to interact with
      state: touch                    # Keyword from predefined list of choices
      mode: 0666                      # Permission mode to be applied
```

Now that we have our playbook defined, we can go ahead and execute our playbook and then verify the results with the following two commands.

```bash
ansible-playbook /etc/ansible/playbook.yaml
ansible ansible_client -a "ls -al /root"
```

To remove the newly created file, update the exiting playbook file with the following content.

```bash
nano /etc/ansible/playbook.yaml
```

```yaml
- hosts: ansible_client
  tasks:
  - name: Creating an empty file
    file:
      path: "/root/playbookTest.txt"
      state: touch
      mode: 0666
    # Add the following
    tags:
      - create
  - name: Remove an empty file
    file:
      path: "/root/playbookTest.txt"
      state: absent
    tags:
      - delete
```

The additional content we added is very similiar to the original content with a few key differences, the addition of tags and changing the keyword from touch to absent.  Whereas the state 'touch' creates a file, the 'absent' state directs the module to delete the file.

By default, executing an ansible playbook causes ansible to execute each task sequentially.  Tags allow us to name specific parts of a playbook, in this instance to the tasks themselves, and gain finer control over the execution of the playbook.

This time we are going to execute just the single task 'delete' based on the tag name use that to remove the file.

```bash
ansible-playbook /etc/ansible/playbook.yaml --tags "delete"
ansible ansible_client -a "ls -al /root"
```

Please note, you were to run the playbook again, without the --tag specifier, you would run both tasks sequentially.  Meaning you would create the file, set its permissions, and then immediately delete it.

## Section 1, Lab 2 YAML Scripting

Now that we have learned a few useful things about ansible playbooks, let's go ahead and work through some of the class examples.  First thing to do, not contaminate our work environment with a server install and instead update our docker compose file to spin up a new node.

### Update the manager nodes hosts

To keep our baseline clean, we will copy over the docker directory under the ansible directory we have been working under and make the changes there.  From the 02_cmWithAnsibleTerraform directory issue the following commands:
```bash

```
## Create webserver node

### Create play book

```yaml
nano node.yml
```

### Populate

```yaml
- hosts: webservers
  become: true
  tasks:
  - name: Playbook
    become: true
  tasks:
  - name: add apt key for nodesource
    become: true
    apt_key: url=https://deb.nodesource.com/gpgkey/nodesource.gpg.key
  - name: add repo for nodesource
    become: true
    apt_repository:
     repo: 'deb https://deb.nodesource.com/node_0.10 {{ ansible_distribution_release }} main'
     update_cache: yes
  - name: install nodejs
    become: true
    apt: name=nodejs
```

### Open firewall

```bash
sudo ufw allow 42006/tcp
```

### Run the playbook

```bash
ansible-playbook node.yml -k -K
```

## Section 1, Lab 3 Apache Web server

### Create play book

```bash
nano apache2.yaml
```

### Populate

```yaml
- hosts: webservers
  become: true
  tasks:
    - name: install apache2
      apt: name=apache2 update_cache=yes state=latest

    - name: enabled mod_rewrite
      apache2_module: name=rewrite state=present
      notify:
         - restart apache2

  handlers:
    - name: restart apache2
      service: name=apache2 state=restarted
```

## Section 1, Lab 6 Working with Roles

```bash
mkdir -p base/roles
cd base/roles
ansible-galaxy init demor
cd demor/tasks
nano main.yml
```

paste

```yaml
---
# tasks file for demor
- name: copy demor file
  template:
     src: templates/demor.j2
     dest: /etc/demor
     owner: root
     group: root
     mode: 0444
```

```bash
cd ../templates
nano demor.j2
```

paste

```yaml
Welcome to {{ ansible_hostname }}

This file was created on {{ ansible_date_time.date }}
Go away if you have no business being here

Contact {{ system_manager }} if anything is wrong
```

```bash
cd ../defaults
nano main.yml
```

paste

```yaml
# defaults file for demor
system_manager: admin@golinuxcloud.com

```bash
cd ../..
nano demor-role.yml
```

paste

```yaml
---

- name: use demor role playbook
  hosts: webservers
  user: ansible
  become: true

  roles:
    - role: demor
      system_manager: admin@golinuxcloud.com
```

Execute

```bash
ansible-playbook demor-role.yml
```

## Section 3, Lab 2 Hosts and Groups

## Section 1, Lab 2 YAML Scripting

## Section 1, Lab 2 YAML Scripting