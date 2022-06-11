#!/bin/bash

# Prepare requirements for jenkins
sudo yum -y update
# sudo amazon-linux-extras enable java-openjdk11
# sudo yum -y clean metadata
sudo yum -y install java-11

# Add the jenkins repo and install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum -y upgrade
sudo yum -y install jenkins

# Enable jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins
# Add the build tools
sudo yum -y install git
sudo yum -y install docker
sudo yum -y install maven

# Turn Services on
sudo systemctl start jenkins
sudo systemctl status jenkins
sudo systemctl start docker
sudo systemctl status docker

echo Jenkins Instance Ready
echo `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`