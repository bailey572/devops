
# Working with Ansible Part 2

## Make Ansible scripts local

To make life easier, lets create a local area to edit and store our ansible scripts to be executed by the ansible_manager.  To do so, we will create a local folder, update the compose file to create a volume, then create a playbook to be injected into the manager container for execution.

### Create local direcoty and file

From the directory ./02_cmWithAnsibleTerraform/ansible, create a playbook directory and our playbook.

```bash
mkdir playbooks
touch ./playbooks/localPlaybook.yaml
```

The power of playbooks really do lie in their reuse.  Complimentary to that is the ability to track changes through change management through a tool like git.  In the real world, I would emphasis how important it is to commit your changes and version control.  In this instance, we are working from a github project and the files are probably already available to you.

Using your favorite text editor, populate the local playbook file with the following content.

```yaml
- hosts: webservers
  tasks:
    - name: install apache2
      apt: name=apache2 update_cache=yes state=latest # update and install from packages

    - name: enabled mod_rewrite
      apache2_module: name=rewrite state=present      # ansible module to enable apache2 
      notify:
         - restart apache2                            # restart the service

  handlers:                                           # create a block handler to restart the service
    - name: restart apache2
      service: name=apache2 state=restarted
```

If the above looks familiar, congradulations on workingh through the first set of notes.  This the same playbook that we created to install and start the apache web server with our custom page directly on the manager node.  Here we are doing the same thing but we can edit it locally and run from manager.

### Create volume

If you recall our earlier exercise in volumes, we are doing the same activity as we did with the webserver but against the manager definition.  Using your favorite text editor, edit the  ./02_cmWithAnsibleTerraform/ansible/docker/docker-compose.yaml file for the hostname: ```ansible_manager``` by adding the following lines.

```yaml
 volumes:
      - ../playbooks/:/root/playbooks:ro    # This will mount the dir as read only
```

This will mount a new volume in our manager container in root's home directory.  Anything that we add or edit locally will automatically be available on that node for execution.

### Run it

Cycle the current set of containers in our docker-compose.yaml file and test out the results.  Because we want everything in a clean state, bring down the containers instead of just stopping them.  This will ensure that previous modificatons that we have made are removed.  Instead of changing directories, we can use the -f flag to point to our file.

```bash
docker-compose -f ./docker/docker-compose.yaml down
docker-compose -f ./docker/docker-compose.yaml up -d
```

Did you notice the ```-d``` flag?  This is a build in flag for docker to run the command detached.  Like the ```&``` puts the process in the background, running detached will keep from blocking your terminal prompt.  They both work and I have not seen an advantage to one or the other.

Now that we are up and running, go ahead and take a looke at the ansible_manager node and verify our new file is present.

```bash
docker exec -it docker_ansible_manager-1 /bin/bash
ls -al /root/playbooks
cat /root/playbooks/localPlaybook.yaml
```

To verify everything is working correctly, go ahead and open your local web browser and go to URL address ```http://localhost:8888/```.  This will give you an error such as page isn't working or session reset depending on your browser but that is to be expected as we have not configured the web server yet.  Let's do that now by executing ansible from the ansible_manager node:

```bash
nsible-playbook /root/playbooks/localPlaybook.yaml 
```

Because the are "new" containers, you will have to type "yes" to accept the connection and add to the known hosts file.  Let the script execute through its steps (isntall, enable, restart) and once finished, refresh your browser.  Your custome web page should now be visible.

## Lesson 6 - Exercising Ansible

Back to class.  The class is running commands against a nodejs system so we will create one and do the same.

### Playing with Ansible loops Lesson 6, Demo 3

### Playing with Ansible conditionals Lesson 6, Demo 4

## Lesson 7 - Jinja2

Create a new node for the installation of Jinja2

### Variables in jinja2Lesson 7, Demo 2

### Variables in jinja2 filters Lesson 7, Demo 5

## Lesson 8 - Playing with roles

## Lesson 9 - Ansible-vault