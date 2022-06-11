#!/bin/bash
sudo yum -y update
sudo yum -y upgrade
sudo yum -y install docker
sudo groupadd docker
sudo usermod -aG docker $USER