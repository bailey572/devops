
# Working with Ansible Part 2

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