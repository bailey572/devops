docker run -t --rm -p 8081:8080 --name webapp \
-v ${PWD}/webapp/target:/usr/local/tomcat/webapps \
tomcat:10-jre11-temurin-focal
