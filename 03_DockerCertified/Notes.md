# Special Love for Docker

Docker Engine supports the tasks and workflows involved to build, ship, and run container
based
applications. The engine creates a daemon process on the server side that hosts volumes of files,
containers, networks, and storage.

Docker consists of:
-The Docker Engine: It is a lightweight and powerful open source containerization technology
combined with a workflow for building and containerizing your applications.
-Docker Hub: It is a Software as a Service (SAAS) for sharing and managing your application
stacks.

## Dockerfile keywords and commands

### FROM

FROM is used to begin a new build stage. This sets the base image for subsequent instructions.

Properties:

- FROM can be written multiple times to create multiple images in a single Dockerfile.
- name is used to name the build stage in a Dockerfile.
- FROM is the first instruction in any Dockerfile. Only ARG can precede FROM
  - where ARG is outside the build stage.
  
#### Syntax

```text
FROM [image] [AS [name]]
```

### RUN

RUN is used to execute commands inside of the Docker image. These commands get executed once at build time and get written into the Docker image as a new layer.

#### RUN Syntax

```text
shell form: RUN <command>
exec form: RUN ["executable", "param1", "param2"]
```

### CMD

CMD used to define a default command to run when the container starts.

#### CMD Syntax

```text
exec form: CMD ["executable","param1","param2"]
default parameters : CMD ["param1","param2"]
shell form: CMD command param1 param2
```

### LABEL

LABELis a key value pair that helps in adding metadata to an image. One image can have multiple labels that can be written in a single instruction.

#### LABEL Syntax

```text
LABEL <key>=<value> <key>=<value> <key>=<value>
```

### ADD

ADD copies new directories, files, and URLs of remote files from *src*. It not only copies the directories, files, and URLs of remote files but also adds them
to the image filesystem at *dest*.

The *dest* is a path where the source is copied in the destination container.

#### Rules obeyed by ADD

1. The path of *src* is required to be included in the context of build.
2. The following occurs when the *src* is a URL and the *dest* does not end with a trailing slash:

- The file is downloaded from the URL and is copied to the *dest*

3. The following occurs when the *src* is a URL and the *dest* ends with a trailing slash:

- The filename is inferred from the URL and the file gets downloaded to the *dest/filename*

4. The contents of the directory and filesystem metadata get copied when the *src* acts as a directory.
5. The *src* is unpacked as a directory when *src* acts as local tar archive in the various compression formats. The compression format can be identity, gzip, bzip2,or xz.
6. The *src* file is copied along with its metadata if the *src* is present in any other format. The *dest* acts as a directory. This holds the contents of *src* that are written at *dest/base/src*, which happens only when the *dest* ends with the trailing slash.
7. The *dest* must act as a directory that ends with a slash “/” when multiple *src* resources are specified.
8. The *dest* is considered as a regular file. The *src* content is written at *dest* when the *dest* does not end with a trailing slash.
9. The *dest* is created along with all the missing directories when the *dest* does not exist.

#### ADD Syntax

```text
ADD [ chown=<user>:<group>] <src>... <dest>
ADD [ chown=<user>:<group>] ["<src>",... "<dest>"]
```

### COPY

The COPY command copies new directories and files from *src*. COPY also adds those new directories and files to the container’s filesystem at the path *dest*

#### Rules obeyed by COPY

1. The path of *src* is required to be included in the context of build.
2. The contents of the directory and filesystem metadata get copied when the *src* acts as a directory.
3. The *src* file is copied along with its metadata if the *src* is present in any other format. 
4. The *dest* is a directory where the *src* contents are written at *dest/base/src*, this happens only when the *dest* ends with a trailing slash.
5. The *dest* must act as a directory and end with a slash “/” when multiple *src* resources are specified.
6. The *dest* is considered as a regular file and the *src* content is written at *dest* when the *dest* does not end with a trailing slash.
7. The *dest* is created along with all the missing directories when the *dest* does not exist.

#### COPY Syntax

```text
COPY [ chown=<user>:<group>] <src>... <dest>
COPY [ chown=<user>:<group>] ["<src>",... "<dest>"]
```

### EXPOSE

EXPOSE sends information to Docker that the container listens on the specified network ports at runtime.

#### EXPOSE Syntax

```text
EXPOSE <port> [<port>/<protocol>...]
```

### ENV

ENV is a key value pair. It sets the *key*, an environment variable, to the value *value*.

#### ENV Syntax

```text
ENV <key> <value>
ENV <key>=<value>
```

### USER

USER assigns user name and user group while running the image. It also assigns user name and user group for the RUN, CMD, and ENTRYPOINT instructions.

#### USER Syntax

```text
USER <user>[:<group>] 
USER <UID>[:<GID>]
```

### VOLUME

VOLUME creates a mount point with a specific name.

#### VOLUME Syntax

```text
VOLUME [“/data”]
```

### WORKDIR

WORKDIR sets the directory for RUN, CMD, ENTRYPOINT, COPY, and ADD instructions.

#### WORKDIR Syntax

```text
WORKDIR /path/to/workdir
```

### ARG

ARG defines the variables that are passed by the user to the builder at the build time. This definition becomes effective from the line on which it is defined in the Dockerfile.

#### Automatic platform ARGs variables:

- TARGETPLATFORM
- TARGETOS
- TARGETARCH
- TARGETVARIANT
- BUILDPLATFORM
- BUILDOS
- BUILDARCH
- BUILDVARIANT

#### ARG Syntax

```text
ARG <name>[=<default value>]
```

### ONBUILD

ONBUILD adds a trigger instruction to an image when the image is used as the base for another build.
The ADD and RUN instructions cannot be used when the image is a reusable application builder, because there is no access to the application source code.
The solution to counter this is to use ONBUILD instructions in advance that can be run during the next build stage.

#### ONBUILD Syntax

```text
ONBUILD ADD . /app/src
ONBUILD RUN /usr/local/bin/python
build dir /app/src
```

### STOPSIGNAL

STOPSIGNAL sends a system call signal that helps the container to exit.

#### STOPSIGNAL Syntax

```text
STOPSIGNAL signal
```

### ENTRYPOINT

ENTRYPOINT in Dockerfile Instruction is used you to configure a container that you can run as an executable.

ENTRYPOINT specifies a commands that will executes when the Docker container starts.

#### Rules for CMD and ENTRYPOINT cooperation

1. CMD or ENTRYPOINT commands must be specified in the Dockerfile.
2. CMD must be used to define default arguments for an ENTRYPOINT command.
3. CMD is overridden when the container is run with alternative arguments.
4. ENTRYPOINT must be defined while using an executable container.

#### ENTRYPOINT Syntax

```text
exec form: ENTRYPOINT ["executable", "param1", "param2"]
shell form: ENTRYPOINT command param1 param2
```

It will execute in /bin/sh c . This form ignores the CMD and docker run command line arguments.

### HEALTHCHECK

HEALTHCHECK helps to identify whether applications are working in the desired fashion or not.
HEALTHCHECK uses the value of exit codes to identify whether the applications are working properly or not.

- 0 for pass
- 1 for fail
- plethora of other numbers

#### HEALTHCHECK Syntax

```text
HEALTHCHECK [OPTIONS] CMD command : This command helps in checking
the container health by running a command inside it.

HEALTHCHECK NONE : This disables the health check that is inherited from
the base image.
```

## Docker utilities

### Flattening

The purpose behind flattening the container is to reduce the size of the container.

### Docker Commit

It commits the changes or settings of a container into a new image. By default, during the process of creating the commit, all the processes are paused as this helps in reduction of data corruption.
While committing, --change option is used to make changes to Dockerfile instructions such as CMD, ENTRYPOINT, ENV, EXPOSE, LABEL, ONBUILD, USER, VOLUME, and WORKDIR.

### Tagging an image

Docker tags provide information about the image version or variant.

#### Tagging during building an image

```text
docker build -t repo_name:version_0.1 .
```

#### Tagging a built image

```text
docker image tag image_name: repository_name:version_0.1 
docker image tag image_name:image_tag repository_name:version_0.1
```
