#!/bin/bash

#Prepare requirements for jenkins
yum -y update
amazon-linux-extras enable java-openjdk11
yum -y clean metadata
yum -y install java-11-openjdk

#add the jenkins repo and install Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum -y upgrade
yum -y install jenkins

#turn jenkins on
systemctl enable jenkins
systemctl start jenkins

password=`cat /var/lib/jenkins/secrets/initialAdminPassword`
CRUMB=$(curl -s 'http://admin:$password@localhost:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')
cat myJenkinsfile.xml | curl -X POST -H $CRUMB 'http://localhost:8080/createItem?name=TestJob' --header "Content-Type: application/xml" -d @-