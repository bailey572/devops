# Dockerfile for WebApp

This is a very simple dockerfile packaging our pre-built sample application, retailone, war file into the tomcat image.
Note:
Before creating the image, ensure that you have a built war file ./sampleTest/RetailWebApp/tatget/retailone.war.
To create one, issue the "mvn package" command from within the ./sampleTest/RetailWebApp directory.
 
To create the image, use the basic build command "docker build . " from the root directory.

To test it manually, run the docker run command with the correct image.  For example
```bash
docker build . 
docker images
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
<none>       <none>    1bc581de7c4c   36 minutes ago   311MB
```

```bash
docker run -d --rm -P 1bc581de7c4c
```
--rm is optional and will remove the container once stopped
-P will map the local machine to the exposed ports in the dockerfile to a local random port.

Use the docker ps command to see what port that is, such as 49153 in the below example/
```bash
docker ps
CONTAINER ID   IMAGE          COMMAND             CREATED          STATUS          PORTS                     NAMES
5180c88632ad   1bc581de7c4c   "catalina.sh run"   15 minutes ago   Up 15 minutes   0.0.0.0:49153->8080/tcp   recursing_mirzakhani
```