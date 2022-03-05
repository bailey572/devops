# Working with Ansible Part 1

My original intent was to work through a series of practice labs that had been assigned in a CalTech Devops class but the presentation of, and source material provided was found to be lacking.  Instead, I assembled this collection of notes based roughly on what was assigned and supplemented them with separate research and logical groupings.

## Spin up test system

If you would like to follow along, I would suggest grabbing the docker-compose based setup to spin up a test system.  Notes for the project are located in the [Notes.md](https://github.com/bailey572/devops/blob/main/02_cmWithAnsibleTerraform/docker/Notes.md).  If you are accessing these locally from a github checkout, they are located in the root 02_cmWithAnsible/docker folder.  I highly suggest reading through them but if not, here is a quick start guide to get you started.
Open a terminal folder and navigate to the 02_cmWithAnsible/docker folder and issue the following commands.

```bash
docker-compose up &
docker exec -it docker_ansible_manager_1 /bin/bash
```

The first command will create a docker network 'ansible-net', two docker images, and two docker containers 'docker_ansible_manager_1 and docker_ansible_client_1 based on those images.  

The second command will attach the current terminal to a bash console, hosted on the docker_ansible_manager_1 node, where we will be directly interacting with that node and most commands will be targeted to the clients through the ansible service.

Please note: depending on your system the container name may change slightly, use the ```docker ps``` command to verify.

## Command line

While it is always recommended to interact with ansible through the use of playbooks, it is sometimes useful to send simple commands straight from the command line and it can be useful for quick experimentation.  The following are a collection of commands with simple explanations.
For some reason, the class decided to provide command line examples over a few different labs so I have included them in here as well.

### Section 1, Lab 4 Command line runs

``` ansible foundation -m shell -a 'hostname' ```

Calls the ansible executable with the following arguments.

- foundation: group defined in the host file.  Ansible will then call each entry node sequentially and issue the command
- m: specifies to run an ansible module
- shell: module to assist in issuing shell commands
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
- An optional --become runs operations with elevated (sudo) privileges but is not required here as we are executing everything as root

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
- a: shorthand for --args to pass into the modules
  - dest: location to place the file
  - state: set to touch to create file
  - mode: octal permissions of the file rw for user only
  - owner: set file owner as user root
  - group: set file group access to root group

This command will create an empty file on the client node  in roots home directory with rm permissions and owned by the root user and group.  

To verify its existence, issue

``` ansible ansible_client -a "ls -al /root/sample.txt" ```

Calls the ansible executable with the following arguments.

- ansible_client: specific node in the host file.
- a: shorthand for --args to pass into the modules.  Default ansible is called
  - ls -al /root/sample.txt:

This command issues the standard linux command to do a long listing of the file /root/sample.txt returning the current permissions.

It should be noted that just about any linux command, or series of commands, can be issued in this manner but it is a bad practice.

***---Do not make it a habit----***

# First Play Book

While we could execute ansible modules directly from the command line, and there are [A LOT](https://docs.ansible.com/ansible/2.7/modules/list_of_all_modules.html) of them to choose from.  Best practices really are to issue the command through Play Books.

Play books are YAML (YAML Ain't Markup Language) scripts containing basically the same parameter arguments that we have been issuing directly from the command line.

Before we get started, lets put a simple text editor on the ansible_manager node.  From root@ansible_manager:/# issue ```apt install nano -y```

For our playbook, let's revisit the earlier command for creating an empty file on the ansible_client machine ``` ansible ansible_client -m file -a 'dest=/root/sample.txt state=touch mode=600 owner=root group=root' ```

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

The additional content we added is very similar to the original content with a few key differences, the addition of tags and changing the keyword from touch to absent.  Whereas the state 'touch' creates a file, the 'absent' state directs the module to delete the file.

By default, executing an ansible playbook causes ansible to execute each task sequentially.  Tags allow us to name specific parts of a playbook, in this instance to the tasks themselves, and gain finer control over the execution of the playbook.

This time we are going to execute just the single task 'delete' based on the tag name to remove the file.

```bash
ansible-playbook /etc/ansible/playbook.yaml --tags "delete"
ansible ansible_client -a "ls -al /root"
```

Please note, were you to run the playbook again, without the --tag specifier, you would run both tasks sequentially.  Meaning you would create the file, set its permissions, and then immediately delete it.

## Section 1, Lab 2 YAML Scripting

Now that we have learned a few useful things about ansible playbooks, let's go ahead and work through some of the class examples.  First thing to do, not contaminate our work environment with a server install and instead update our docker compose file to spin up a new node.

### Create a play area

To keep our baseline clean, we will copy over the docker directory under the ansible directory we have been working under and make the changes there.  From the 02_cmWithAnsibleTerraform directory in a terminal, issue the following commands:

```bash
cp -r docker/ ansible/
rm ansible/docker/Notes.md
```

These commands will move all the docker directory and its contents as a sub directory under ansible, remove the notes page, and navigate us to a known location for the rest of our work.

### Create a webserver node

Our first step is to use the client node as the baseline for our new webserver by copying the client directory contents to a new directory webserver.

```bash
cp -r client webserver
```

Usually, we would modify the ./webserver/Dockerfile to configure our webserver but for this exercise we are going to use ansible to do so against our base client image.  Because of this, we do not need to modify the Dockerfile at all.

### Add webserver to the environment

Update the docker-compose.yaml file directly after the ansible_client definition ending on line 43 (ex: tty: true)

```yaml
  webserver:
    # Set a static hostname in the image so we do not have to use IP's
    hostname: webserver
    # Define the build section to define how to create the client docker image
    build: 
      # Define relative path starting location
      context: '.'
      # Set location of Dockerfile for image build
      dockerfile: "./webserver/Dockerfile"
    # define list of exposed ports that Compose implementations MUST expose from container.  Expose is only relevant to the docker network, not any further.
    expose: 
      - 22
    # We are adding ports to give access to the webserver to the local host
    ports:
      - "127.0.0.1:8888:80"
    # assign to ansible network
    networks:
      - ansible-net
    # Tell compose to keep containers running interactive and with a tty
    stdin_open: true # docker run -i (interactive)
    tty: true        # docker run -t (tty)
```

This is practically the same information as the ansible_client definition but we with four simple changes:

- changed the node definition to webserver
- defined the hostname for the system
- pointed to a new dockerfile. This is not necessary but cleaner, we could have just used the same file.
- added ports: - "127.0.0.1:8888:80". This line will expose our node to the local host and map port 8888 to the nodes port 80.

This will result in docker spinning up three separate nodes on the next ```docker-compose up``` command.

The last step required to setup our environment is to update the ./manager/ansible_hosts in order to add the webserver node.  We will not only add the hostname but include it into a new group called webservers.

```bash
[foundation]
ansible_manager
ansible_client
# Add the following
[webservers]
webserver
```

Thats it, we are done.

### Spin up the environment

From the same root directory we can spin up all three nodes and then connect to the manager.  To see the true power of this configuration, you might want to start from a clean state.  We can do this with a few quick commands.

```bash
docker-compose down -v --rmi all --remove-orphans
docker system prune               # clean up orphans
docker images                     # get a list of image ID's for the docker images
docker rmi ID#1 ID#1 ID#1         # replace ID# with actual ID's to delete all images
```

To run our new environment, we just need to bring it up and attach to the ansible_manager.
Please note: depending on your system, the container name may change slightly, use the ```docker ps``` command to verify.

```bash
docker-compose up &
docker exec -it docker_ansible_manager-1 /bin/bash
```

Once you are connected to ```root@ansible_manager:/#```, verify access with a quick ```ssh webserver``` command to establish connectivity and we are set.  Exit out of webserver to return to the ansible_manager command line.

### Update the play book

Now we can use ansible to turn our generic node into a webserver by installing Apache on it.  On the master node, we will create a new playbook but first we need to install nano.

```bash
apt install nano
nano /etc/ansible/apache2.yml
```

and populate with:

### Populate apache2.yml

With the empty text file opened in the nano editor, we can paste the following content:

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

Save the file and we are ready to pass it over to ansible to run the configuration.

### Run the playbook

```bash
ansible-playbook /etc/ansible/apache2.yml
```

This will take our, basically useless node, install the apache web server on it and then start the service all in one go.  Because we specified ports in the docker-compose file, we are able to access it from the host system through the local web browser.  To verify apache is running, open a web browser and go to the address ```http://localhost:8888/``` to see the default web page.

***
***WARNING: Deleting or rebuilding the container will require running the playbook again***
***

## Create a volume

Before we move forward and discard this setup, lets go ahead and look at another really neat feature. Declaring a volume mount declaratively through docker-compose.  For this we will create an empty directory, create a static web page file inside it, and then update the docker-compose.yml file to mount the webserver container to the local file system and display our web page.

### Create Web page

To start, return to the host terminal by exiting ansible_manager by issuing ```exit``` and return to the root of our ```./ansible/docker``` area, the one with the docker-compose.yaml file in it, on the host system.

From there, we can stop the current containers.  Stop allows us to halt their execution without being destructive.  

```bash
docker-compose stop 
```

In all honesty, we could have just stopped one node by appending the ```webserver``` node name in the command, but there is no harm in bringing them all down.

Now, create a directory under webserver and add an index.html file.

```bash
mkdir webserver/apache
touch webserver/apache/index.html 
```

Using a text editor of your choice, populate the webserver/apache/index.html file with the content of you choice or copy and past the below example.

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf8">
    <title>Apache2 Home</title>
    <style>
        .head1 {
            font-size:40px;
            color:#7a0099;
            font-weight:bold;
        }
        .head2 {
            font-size:17px;
            margin-left:10px;
            margin-bottom:15px;
        }
        body {
            margin: 0 auto;
            background-position:center;
            background-size: contain;
        }
     
        .menu {  
            position: sticky;
            top: 0;
            background-color: #940099;
            padding:10px 0px 10px 0px;
            color:white;
            margin: 0 auto;
            overflow: hidden;
        }
        .menu a {
            float: left;
            color: white;
            text-align: center;
            padding: 14px 16px;
            text-decoration: none;
            font-size: 20px;
        }
        .menu-log {
            right: auto;
            float: right;
        }
        footer {
            width: 100%;
            bottom: 0px;
            background-color: #000;
            color: #fff;
            position: absolute;
            padding-top:20px;
            padding-bottom:50px;
            text-align:center;
            font-size:30px;
            font-weight:bold;
        }
        .body_sec {
            margin-left:20px;
        }
    </style>
</head>
 
<body>
     
    <!-- Header Section -->
    <header>
        <div class="head1">New Apache2 Custom Home Page</div>
        <div class="head2">Replacement for default page</div>
    </header>
     
    <!-- Menu Navigation Bar -->
    <div class="menu">
        <a href="#home">HOME</a>
        <a href="#link1">LINK 1</a>
        <a href="#link2">LINK 2</a>        
    </div>
     
    <!-- Body section -->
    <div class = "body_sec">
        <section id="Content">
            <h3>Content section</h3>
        </section>
        <h1>This is heading 1</h1>
        <h2>This is heading 2</h2>
        <h3>This is heading 3</h3>
        <p>This is a paragraph.</p>
        <p>This is another paragraph.</p>
    </div>
     
    <!-- Footer Section -->
    <footer>Footer Section</footer>
</body>
</html>  
```

### Create the volume

To create the mount point and replace the existing default apache web page we will update the existing docker-compose file with two additional lines under the webserver node.

Insert the following lines between ```ports``` and ```networks```.  It could go elsewhere but this is as good a place as any.

```yaml
ports:
      - "127.0.0.1:8888:80"
    # assign to ansible network
    volumes:
      - ./webserver/apache:/var/www/html:ro    # This will mount the dir as read only
```

### Run it

Now we just need to bring the containers back up.

Because we used ansible to start the service last time but brought down the system, we have a couple of options.  
- we could rerun the ansible script from the manager node
- we could manually start the service from the webserver node

To mix things up, lets go ahead and connect directly with the webserver and manually start the service

```bash
docker-compose up &
docker exec -it docker-webserver-1 /bin/bash
service apache2 start
```

**THAT IS IT!!!**.  You can now open your local web browser and go to the address ```http://localhost:8888/``` to see your new web page.

Even better, if you modify the local file, save the file, and refresh your browser you can see the changes immediately.
