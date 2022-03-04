
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

Back to class.  The class is running commands against a nodejs system so we quickly make sure that we do the same.will create one and do the same.  Some of the information is good to have and some is just redundant.  For instance Lesson 6, Lab 1 introduces you to running a preconfigured YAML script, which we just covered to greater detail, so I am going to skip that lab.  For completeness, below is the script with bonus material explaining what it is doing (something missing from the lab itself) through comments.  Feel free to run it.

```yaml
- name: install nodejs  # friendly name of the play
  hosts: webservers  # target node to run against
  gather_facts: True # tells ansible to gather information about node
  become: true # elevate privelages, will not work with our docker images since we are running as root
  tasks: # section for collection of named tasks
   - name: add apt key for nodesource # label for task
     apt_key: url=https://deb.nodesource.com/gpgkey/nodesource.gpg.key # pull down public key for Node.js for NODESOURCE
   - name: add repo for nodesource # label for task
     apt_repository:
      repo: 'deb https://deb.nodesource.com/node_0.10 {{ ansible_distribution_release }} main' # add repository to our image list 
      update_cache: no
   - name: install nodejs # install the nodeJS service and dependencies
     apt: name=nodejs # will usually make sure service is started
     #state: present # best practice is to make sure state is set (not in lab exercise)
```

As you can see, this will install and NodeJS service, which is an open-source, cross-platform, JavaScript runtime environment that executes JavaScript code outside of a web browser.  If you are doing development or want to unit test your javascript without depending on a browser, NodeJS is your best friend.

Exercise two is all about variables, ok it shows that ansible supports variables like every other scripting language, with the simple playbook:

```yaml
 - hosts: all # will run against all nodes in your /etc/ansible/hosts file
   vars: # creates a block of variables
     salutations: Hello guys! # create variable and gives it a value
   tasks:  # section for collection of named tasks
   - name: Ansible Variable Basic Usage
     debug:
       msg: "{{ salutations }}"
```

This is one worth running, if a little light.  Remeber the work we did to share an area on our local host system with a mount point in our ansible_manager?  Let's use that now.

On your local system, create a new text file ```basicVariable.yaml``` in the ```02_cmWithAnsibleTerraform/ansible/playbooks/``` folder we are referencencing in docker-compose.yaml file at about line 22, ```- ../playbooks/:/root/playbooks:ro```  and paste the above playbook cofiguration from above and save it.

Now for the fun part.  Make sure your containers are running and attach a termnal to ansible_manager by opening up a terminal, navigating to the directory containing our ```docker-compose.yaml``` file located in ```YOUR_DEV_DIR/02_cmWithAnsibleTerraform/ansible/docker/```, and issueing:

```bash
docker-compose up -d
docker exec -it docker_ansible_manager-1 /bin/bash
```

Please note: depending on your system, the '_' may be replaced with '-' in the generated numbers.  I bounce between three systems and have been too lazy to figure out what variable controls the generation but a quick ```docker ps``` will give you the correct name.

Now that we are logged into the ansible-manager, we can verify that our local file is available.

```bash
ls -al /root/playbooks
cat /root/playbooks/basicVariable.yaml
```

I LOVE IT!!!  The best part is, we can edit, add, remove, whatever and not have to stop or rebuild our image or containers. This not only makes it easy to develop but also allows us to push and pull from a source repository like git without having to modify any of the docker stuff.

Let's go ahead and run it to test the variable usage.

```bash
ansible-playbook /root/playbooks/basicVariable.yaml
```

This will run through all of our nodes and show you the message, exciting no but it gets the job done.  
### Playing with Ansible loops Lesson 6, Demo 3

### Playing with Ansible conditionals Lesson 6, Demo 4

## Lesson 7 - Jinja2

Create a new node for the installation of Jinja2

### Variables in jinja2Lesson 7, Demo 2

### Variables in jinja2 filters Lesson 7, Demo 5

## Lesson 8 - Playing with roles

## Lesson 9 - Ansible-vault