# Get Ansible up and running 

## Build Control Node

### Install

```
sudo apt update; sudo apt upgrage -y; sudo apt isntall ansible -y
```

### Build Inventory

```
sudo nano /etc/ansible/hosts
```

```
[linux]
#first-vm
192.168.122.46
#Devops_1
192.168.122.43
#asus
192.168.1.39
#insp
192.168.1.229
```

## Add remote nodes

### Generate new keys

We will need to gereneate RSA keys and then share the public portion with each node to enable login without having to supply a password

```
ssh-keygen
```

When prompted change file name from default from id_rsa to something memorable, such as ~/.ssh/ansible_rsa

### Add authorize_keys

Don't just use scp, use the ssh-copy-id program.

```
ssh-copy-id remote_username@server_ip_address
```

This will create the authorized_keys file under your .ssh folder.

### Test auto-login

Perform a normal ssh login, you should no lnoger need to supply a password.

Repeat ssh-copy-id for all nodes in your inventory.

##  Test your setup

### Create a playbook

```
nano test.yaml

---
- name: First playbook
  hosts: all
  tasks:
     - name: Leaving a mark
       command: "touch /tmp/ansible_was_here"

ansible-playbook test.yaml
```
You should see the execution of our playbook, which first gathers all the facts before executing our task cretaing the /tmp/ansible_was_here file.
Go ahead and login to the nodes to see they all contain the new file.

### Gathering fact

Interested in all the nodes?  Issue the below command to see what ansible knows or can find out.

```
ansible all -m ansible.builtin.setup | less
```

