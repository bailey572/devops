
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

If the above looks familiar, congradulations on working through the first set of notes.  This the same playbook that we created to install and start the apache web server with our custom page directly on the manager node.  Here we are doing the same thing but we can edit it locally and run from manager.

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
   - name: Ansible Variable Basic Usage # label for task
     debug: # built in print statement
       msg: "{{ salutations }}" # dereference variable and pass to msg function
```

This is one worth running, if a little light.  Fun fact, you would think the line ```debug:``` turns on the ansible debugger but nope, this command leverages the built in print statement run during execution.  Handy, but if you are really interested in debugging, take a look a the [Debugging tasks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_debugger.html) documentation.

Moving on, remeber the work we did to share an area on our local host system with a mount point in our ansible_manager?  Let's use that now.

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

This will run through all of our nodes and show you the message, exciting no, but it gets the job done and you should see the following:

```bash
TASK [Ansible Variable Basic Usage] **********************************************************************************************************************************************
ok: [ansible_manager] => {
    "msg": "Hello guys!"
}
ok: [ansible_client] => {
    "msg": "Hello guys!"
}
ok: [webserver] => {
    "msg": "Hello guys!"
}
```

### Playing with Ansible loops Lesson 6, Demo 3

There is a lot of different ways that we could exercise variables but Lesson 6, Demo3 is a pretty good example and introduces loops and logic in ansble.  Go ahead and create a new file ```loops.yaml``` in the ```02_cmWithAnsibleTerraform/ansible/playbooks/``` directory, paste the following code, and save it.

```yaml
--- # denotes start of YAML, not required but good practice
  - hosts: ansible_client # target the ansible_client node
    tasks: # section for collection of named tasks
    - name: loop # task name
      debug: # built in print statement
        msg: "{{ item }}" # dereference variable and pass to msg function
      loop: # built in function to iterate over list
        - loop_one # create a two item 'list' for the for function
        - loop_two
    - name: with_items # task name
      debug: # built in print statement
        msg: "{{ item }}" # dereference variable and pass to msg function
      with_items: # deprecated function replaced by loop and flatten filter to iterate over list
        - with_one # create a two item 'list' for the for function
        - with_two
    - name: with_indexed_items # task name
      debug:
        msg: "{{ item.0 }} - {{ item.1 }}"
      with_indexed_items: # deprecated function replaced by loop and flatten filter to iterate over list
        - index_one # create a two item 'list' for the for function
        - index_two
```

Since you should still have a terminal connection to ansible_manager we can easily run the new playbook.  If not, go ahead and connect with ```docker exec -it docker_ansible_manager-1 /bin/bash``` before continueing.

```bash
ansible-playbook /root/playbooks/loops.yaml
```

Upon execution of the playbook, you will see the print messages exercised through three unique methods available in ansible (loop, with_items, and with_indexed_items).  They each perform the same basic function and the two 'with' options have actually been depricated with the loop, the flatten filter and loop_control.index_var controls since version 2.8 but you will still see their use often.  The official [documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html#iterating-over-a-simple-list) provides some better examples and I have assembled them below.  Go ahead and create a new file ```exampleLoops.yaml``` in the ```02_cmWithAnsibleTerraform/ansible/playbooks/``` directory, paste the following code, and save it.

```yaml
--- # denotes start of YAML, not required but good practice
  - hosts: ansible_client # target the ansible_client node
    vars: # create a block of variables
      globalItems:
        - global_one # create a two item 'list' for the for function
        - global_two
      list_one:
        - list_one_one
        - list_one_two
      list_two:
        - list_two_one
        - list_two_two
      global_dict: {dict_one, dict_two }

    tasks: # section for collection of named tasks
    - name: with_list
      ansible.builtin.debug:
        msg: "{{ item }}"
      with_list:
        - one
        - two

    - name: with_list -> loop
      ansible.builtin.debug:
        msg: "{{ item }}"
      loop:
        - one
        - two
    
    - name: with_items
      ansible.builtin.debug:
        msg: "{{ item }}"
      with_items: "{{ globalItems }}"

    - name: with_items -> loop
      ansible.builtin.debug:
        msg: "{{ item }}"
      loop: "{{ globalItems|flatten(levels=1) }}"
    
    - name: with_indexed_items
      ansible.builtin.debug:
        msg: "{{ item.0 }} - {{ item.1 }}"
      with_indexed_items: "{{ globalItems }}"

    - name: with_indexed_items -> loop
      ansible.builtin.debug:
        msg: "{{ index }} - {{ item }}"
      loop: "{{ globalItems|flatten(levels=1) }}"
      loop_control:
        index_var: index
  
    - name: with_flattened
      ansible.builtin.debug:
        msg: "{{ item }}"
      with_flattened: "{{ globalItems }}"

    - name: with_flattened -> loop
      ansible.builtin.debug:
        msg: "{{ item }}"
      loop: "{{ globalItems|flatten }}"

    - name: with_together
      ansible.builtin.debug:
        msg: "{{ item.0 }} - {{ item.1 }}"
      with_together:
        - "{{ list_one }}"
        - "{{ list_two }}"

    - name: with_together -> loop
      ansible.builtin.debug:
        msg: "{{ item.0 }} - {{ item.1 }}"
      loop: "{{ list_one|zip(list_two)|list }}"

    - name: with_together -> loop
      ansible.builtin.debug:
        msg: "{{ item.0 }} - {{ item.1 }} - {{ item.2 }}"
      loop: "{{ data[0]|zip(*data[1:])|list }}"
      vars:
        data:
          - ['a', 'b', 'c']
          - ['d', 'e', 'f']
          - ['g', 'h', 'i']
   
    - name: with_dict
      ansible.builtin.debug:
        msg: "{{ item.key }} - {{ item.value }}"
      with_dict: "{{ global_dict }}"

    - name: with_dict -> loop (option 1)
      ansible.builtin.debug:
        msg: "{{ item.key }} - {{ item.value }}"
      loop: "{{ global_dict|dict2items }}"

    - name: with_dict -> loop (option 2)
      ansible.builtin.debug:
        msg: "{{ item.0 }} - {{ item.1 }}"
      loop: "{{ global_dict|dictsort }}"
    
    - name: with_sequence
      ansible.builtin.debug:
        msg: "{{ item }}"
      with_sequence: start=0 end=4 stride=2 format=testuser%02x

    - name: with_sequence -> loop
      ansible.builtin.debug:
        msg: "{{ 'testuser%02x' | format(item) }}"
      # range is exclusive of the end point
      loop: "{{ range(0, 4 + 1, 2)|list }}"

    - name: with_nested
      ansible.builtin.debug:
        msg: "{{ item.0 }} - {{ item.1 }}"
      with_nested:
        - "{{ list_one }}"
        - "{{ list_two }}"

    - name: with_nested -> loop
      ansible.builtin.debug:
        msg: "{{ item.0 }} - {{ item.1 }}"
      loop: "{{ list_one|product(list_two)|list }}"

    - name: with_random_choice
      ansible.builtin.debug:
        msg: "{{ item }}"
      with_random_choice: "{{ globalItems }}"

    - name: with_random_choice -> loop (No loop is needed here)
      ansible.builtin.debug:
        msg: "{{ globalItems|random }}"
      tags: random
```

Move over to the ansible_manager command line and run the playbook.

```bash
ansible-playbook /root/playbooks/exampleLoops.yaml
```

This will show almost all of the options currently available in ansible.  Some of the website examples referenced variables that were not created, so I went ahead and added them as global playbook level variable.  This is actually a pretty good way to see local and playbook scope variables and even introduces the dictionary type.  I created a lazy definiton.  Please see, [YAML Syntax](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html) for better examples.

### Playing with Ansible conditionals Lesson 6, Demo 4

For the last part of lesson 6, lets go ahead and explore some of the conditional stetements found in ansible.  Go ahead and create a new file ```conditionals.yaml``` in the ```02_cmWithAnsibleTerraform/ansible/playbooks/``` directory, paste the following code, and save it.

```yaml
--- # denotes start of YAML, not required but good practice
- hosts: ansible_client # target the ansible_client node
  tasks:
  - name: "Checking OS Family"
    debug: # built in print statement
      msg: "You are running a {{ansible_facts['os_family']}} OS, distrobution {{ansible_facts['distribution']}} version {{ansible_facts['distribution_major_version']}}"
    when: ansible_facts['os_family'] == "Debian"
```

Move over to the ansible_manager command line and run the playbook.

```bash
ansible-playbook /root/playbooks/conditionals.yaml
```

This simple test is used to poll the ```os_family``` and ```distribution_major_version``` variable.  In our case, it is Debian as can be verified with the command ```ansible all -m ansible.builtin.setup``` and viewing the  ```"ansible_os_family": "Debian"``` line in the output.

The ```when``` conditional is a little interesting if you are use to other languages as it appears at the end of the exectution block with all actual commands only executing on true.  This messed with my head a little the first time I encountered it.

Additionally, you may have noticed that I replaced the example text ```command: echo "Sample Message"``` with a debug message function.  I did this for two reasons. 

- I do not like registering changes if I am not doing anything, which the echo command will do
- I wanted to be able to see the results for the ansible_manager isntead of dumping it to the client output

To see an example of multiple logical compares using the ```and``` keyword, ```or``` works the same way, and is only true when both are true.  Because this is YAML, you MUST enclose the conditional statement in paranthesis ```(CONDITIONS)``` if more that one codition is used.  
Go ahead and add the two named tasks to our  ```conditionals.yaml``` file and run it again from the ansible_manager to simulate an if/else logic.

```yaml
  - name: "Is correct version"
    debug: 
      msg: "You are running the correct version"
    when: (ansible_facts['os_family'] == "Debian" and ansible_facts['distribution_major_version'] == "18")
  - name: "Is not correct version"
    debug: 
      msg: "You are NOT running the expected OS version"
    when: (ansible_facts['os_family'] == "Debian" and ansible_facts['distribution_major_version'] != "18")
```

You may ask yourself, why would you use a series of ```when``` statements instead of an ```if``` statement?  Because ansible only support when with ansible_facts, see [Conditionals](https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html) on the official site for more information.

## Lesson 7 - Jinja2
Lesson 7 is fairly short and provides an introduction into leveraging jinja2 through ansible for more complex coding.  Jinja2 is a templating language for the interpretaion of Python commands, often used to add Python processing to web pages.  We will be using it to enhance Ansible.  If you are interested in more information check out the official documentation at [Jinja2](https://jinja2docs.readthedocs.io/en/stable/).

Generally, we would need to update our Docker image to install but Jinja2 is so common, it was already installed with Ansible.  You can verify this by querying the debian package manager.

```bash
dpkg-query -l | grep python-jinja2
```

You should be able to see version such as ```2.10-1ubuntu0.18.04.1``` is already available.  If not, then go ahead and install from ansible_manager comamand line with ```sudo apt-get install -y python-jinja2```.  Yep, the etire point of lab 1 with not real background on it.  Guess they hope the instructor tells you why.

### Variables in jinja2Lesson 7, Demo 2

I almost left this one out as it has a really light use in our ansible class but thought I might as well document what the intent is as it is not really really clear.

For this exercise, we will create two two files.  The first ```index.j2``` will hold some content that jinja2 can interact with and the second ```jinja2_apache.yaml``` will be our playbook that leverage the jinja2 code.

To start with, we will need to change our current docker-compose cofiguration for the ```webserver``` mount to allow the volume to be writable.  We will not touch the other images, containers.
First, edit the ```02_cmWithAnsibleTerraform/ansible/docker/docker-compose.yaml``` file to remove the ``ro`` parameter from our mount

```yaml
# FROM
- ./webserver/apache:/var/www/html:ro
# TO
- ./webserver/apache:/var/www/html
```

Once the update is saved, we will need to not only restart the webserver but also remove the existing volume and create a new one.  This is easier done than said, so don't panic.

Open a termial, or reuse an existing one on the local host and navigate to the ```02_cmWithAnsibleTerraform/ansible/docker/``` directory then issue:

```bash
docker-compose down
docker-compose up -d
```

Once your containers come back up, they are all once again in a clean state and all previous changes will be gone.  Luckily, we have saved all of our scripts on the local host mounted as a volume, so to reinstall the apache web service reuising our existing script, once we attach to the ansible_manager, we need only the following commands.

```bash
docker exec -it docker_ansible_manager-1 /bin/bash
ansible-playbook /root/playbooks/localPlaybook.yaml
```

This will once again install our apache pakcage and start the service.  To start the jinja2 specific exercise create a new file ```index.j2``` in the ```02_cmWithAnsibleTerraform/ansible/playbooks/``` directory, paste the following code, and save it.

```yaml
A message from {{ inventory_hostname }}
{{ webserver_message }}
```

Now create a new file ```jinja2_apache.yaml``` in the ```02_cmWithAnsibleTerraform/ansible/playbooks/``` directory, paste the following code, and save it.

```yaml
---
- name: Check if Apache is working # name the entire play
  hosts: webservers # will hit all nodes in webserver group. We only have one right now
  vars:
    webserver_message: "I am running to the finish line." # populate variable that will be pulled from jinja2 file
  tasks:
    - name: Start apache2 # just make sure that apache is starter
      service:
        name: apache2
        state: started
    # this block will use the jinja2 source in index.j2 to create a new jinja.html file 
    - name: Create index.html using Jinja2 
      template:
        src: index.j2
        dest: /var/www/html/jinja.html
```

From here, we can run the jinja2_apache.yaml playbook from the ansible_manager node and create a new html file that has been customized through the jinja2 script.

```bash
ansible-playbook /root/playbooks/jinja2_apache.yaml
```

Open a browser on your host system and enter ```http://localhost:8888/jinja.html``` as the URL.  This will display the html file custom created by jinja2 for that node.  

```html
A message from webserver I am running to the finish line.
```

In this simple test case, the name "webserver" was pulled from the ansible inverntory variable inventory_hostname and the message from the ansible playbooks local variable webserver_message.  The original exercise was to overwrite the default homepage index.html but I didn't want to.

Impressive? Not really, but it does provide a good foundation for Demo 4.

What about Lesson 7, Demo 3 you might ask?  Waste of time that does less than what we have already gone over, so I have not included here.
### Variables in jinja2 filters Lesson 7, Demo 5

## Lesson 8 - Playing with roles

## Lesson 9 - Ansible-vault