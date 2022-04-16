# Get Ansible up and running

## Build Control Node

### Install

```bash
sudo apt update; sudo apt upgrade -y; sudo apt install ansible -y
```

### Build Inventory

```bash
sudo nano /etc/ansible/hosts
```

```bash
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

We will need to generate RSA keys and then share the public portion with each node to enable login without having to supply a password

```bash
ssh-keygen
```

When prompted change file name from default from id_rsa to something memorable, such as ~/.ssh/ansible_rsa

### Add authorize_keys

Don't just use scp, use the ssh-copy-id program.

```bash
ssh-copy-id remote_username@server_ip_address
```

This will create the authorized_keys file under your .ssh folder.

### Test auto-login

Perform a normal ssh login, you should no longer need to supply a password.

Repeat ssh-copy-id for all nodes in your inventory.

## Test your setup

### Create a playbook

```bash
nano test.yaml

---bash
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

```bash
ansible all -m ansible.builtin.setup | less
```
