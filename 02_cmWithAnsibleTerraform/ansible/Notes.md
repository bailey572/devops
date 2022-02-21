# Working with Ansible

My original intent was to work through a series of practice labs that had been assigned in a CalTech Devops class but the presentation of, and source material provided was found to be lacking.  Instead, I assembled this collection of notes based roughly on what was assigned and supplemented them with seperate research and logical groupings.

## Spin up test system

If you would like to follow along, I would suggest grabbing the docker-compose based setup to spin up a test system.  Notes for the project are located in the[Notes.md](https://github.com/bailey572/devops/blob/main/02_cmWithAnsibleTerraform/docker/Notes.md).  If you are accessing these locally from a github checkout, they are located in the root 02_cmWithAnsible/docker folder.  I highly suggest reading through them but if not, here is a quick start needed to get started.
Open a terminal folder and navigate to the 02_cmWithAnsible/docker folder and issue the following commands.

```bash
docker-compose up
docker exec -it docker_ansible_manager_1 /bin/bash
```

The first command will create a docker network 'ansible-net', two docker images, and two docker containers 'docker_ansible_manager_1 and docker_ansible_client_1 based on those images.  The second command will attach the current terminal to a bash console hosted on docker_ansible_manager_1.

This docker_ansible_manager_1 will be the main device we will be directly interacting with while most commands will be targeted to the clients through the ansible service.

## Command line

While it is always recommended to interact with ansible through the use of playbooks, it is sometimes useful to send simple commands straight from the command line and it can be useful for quick experimentation.  The following are a collection of commands with with simple explanations.
For some reason, the class decided to provide command line examples over a few different labs so I have included them in here as well.

### Section 1, Lab 4 Command line runs

``` ansible foundation -m shell -a 'hostname' ```

Calls the ansible executable with the following arguments.

- foundation: group defined in the host file.  Ansible will then call each entry node sequentially and issue the command
- m: specifies to run an ansible module
- shell: module to assist in issueing shell commands
- a: shorthand for --args to pass into the module
- hostname: linux command to retrieve the name of the system
This will sequentially walk through all members of the foundation group and issue the hostname function.

``` ansible ansible_client -m apt -a 'name=git state=present' ```

Calls the ansible executable with the following arguments.

- ansible_client: specific node in the host file.
- m: specifies to run an ansible module
- apt: module to assist in installing packages.  If the target was a Redhat box, would convert to native Yum cammand
- a: shorthand for --args to pass into the module
  - The name and the state parameter values are then passed in
  - present tells the module to install if not already present
- An optional --become run operations with with elevated privelages 

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

``` ansible -m setup ansible_client ```

Calls the ansible executable with the following arguments.

- m:
- setup: module to gather facts on system/group

# First Play book

If not already done, install the nano text editor ```apt install nano```
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

Please note, you were to run the playbook again, without the --tag specifier, you would run both tasks sequentially.  Meaning you would creat the file, set its permissions, and then immediately delete it.


Interested in all the nodes?  Issue the below command to see what ansible knows or can find out.

```bash
ansible all -m ansible.builtin.setup | less
```

## Section 1, Lab 2 YAML Scripting 
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