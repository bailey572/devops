
# Working with Ansible Part 3

## Default ansible var locations

https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html

Ansible creates an inventory of variables at run time based on when they are defined based on time and scope.  The precedence in how variables are assigned value matters in ansible and there are more that 20 ways to define them.

Ansible does apply variable precedence, and you might have a use for it. Here is the order of precedence from least to greatest (the last listed variables override all other variables):

1. command line values (for example, -u my_user, these are not variables)
2. role defaults (defined in role/defaults/main.yml) 1
3. inventory file or script group vars 2
4. inventory group_vars/all 3
5. playbook group_vars/all 3
6. inventory group_vars/* 3
7. playbook group_vars/* 3
8. inventory file or script host vars 2
9. inventory host_vars/* 3
10. playbook host_vars/* 3
11. host facts / cached set_facts 4
12. play vars
13. play vars_prompt
14. play vars_files
15. role vars (defined in role/vars/main.yml)
16. block vars (only for tasks in block)
17. task vars (only for the task)
18. include_vars
19. set_facts / registered vars
20. role (and include_role) params
21. include params
22. extra vars (for example, -e "user=my_user")(always win precedence)

The set of commands below set up a basic test to demonstrates precedence by leveraging the default ansible search path directories host_vars and group_vars and how they get applied.

```bash
# Populate our directories and file content
mkdir host_vars
mkdir group_vars 

# Edit file and add content
nano host_vars/client1 
usr1: myuser1
mystate: present
pkg: telnet

# Edit file and add content
nano host_vars/client2 
usr1: myuser2
mystate: present
pkg: apache2

# Edit file and add content
nano host_vars/webserver
usr1: myuser3
mystate: absent
pkg: sshd

# Edit file and add content
nano group_vars/all.yml 
myvar: hello
mystate: present
usr1: FromAll
pkg: telnet

# Edit file and add content
nano userhostfile.yml 
- name: User Account Management
  hosts: all
  become: true
  tasks:
          - name: Add simplilearn User Group
            group:
              name: simplilearn
          - name: Add  "{{ usr1 }}"
            user:
              name: "{{ usr1 }}"
              state: "{{ mystate }}"
          - name: printing the pkg value
            debug:
                   msg: "{{ pkg }}"
          - name: printing the usr1 value
            debug:
                   msg: "{{ usr1 }}"
          - name: printing the myvar value
            debug:
                   msg: "{{ myvar }}"
```

When you run the yaml script, you should notice a few things.

- The files holding the variables DO NOT need to end in .yml or .yaml
- The host variables are picked up based on the host name of the file
- Since manager did not have anything defined, its values were all pulled from all.yml

Don't believe me, just rename all.yml to all and run again.  Works the same.

## Lesson 8 - Playing with roles

I am not going to lie, Roles are just a preformatted configuration for working with Ansible.  I could do a write up but [tutorialpoint](https://www.tutorialspoint.com/ansible/ansible_roles.htm?msclkid=cedc0ec6bd9611eca94e082ea301bb22) does a much better job than I.  Basically, use the tool a create the structure.

```bash
$ ansible-galaxy init --force --offline vivekrole 
- vivekrole was created successfully 

$ tree vivekrole/ 
vivekrole/ 
├── defaults 
│   └── main.yml 
├── files ├── handlers 
│   └── main.yml 
├── meta 
│   └── main.yml 
├── README.md ├── tasks 
│   └── main.yml 
├── templates ├── tests │   ├── inventory 
│   └── test.yml 
└── vars 
    └── main.yml 
 
8 directories, 8 files
```

## Lesson 9 - Ansible-vault

Ansible-vault is the command-line tool, which is used on the Ansible server to do below tasks

- Encrypt an existing important file.
- Decrypt an encrypted file.
- View an encrypted file without breaking the encryption.
- Edit an encrypted file and maintain its encryption and secret key/ password.
- Create a new encrypted file.
- Rekey or reset the password of an already encrypted file.

### Encrypt existing

```bash
touch testVault.txt
ansible-vault encrypt testVault.txt
  New Vault password:
  Confirm New Vault password:
  Encryption successful
```

### Decrypt

```bash
ansible-vault decrypt testVault.txt
Vault password:
Decryption successful
```

### View encrypted

```bash
ansible-vault view testVault.txt
Vault password:
```

### Edit encrypted

```bash
ansible-vault edit testVault.txt
Vault password:
```

### Create new encrypted

```bash
ansible-vault create testVault2.txt
New Vault password:
Confirm New Vault password
```

### Reset password

```bash

```
