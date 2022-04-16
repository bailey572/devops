# Collection of Random notes on Jenkins

## From kyle.hewitt@ngc.com to All Participants

Jenkins and Github integration

```text
http://54.154.42.106:8080/github-webhook/
from kyle.hewitt@ngc.com to All Participants:
https://www.cprime.com/resources/blog/how-to-integrate-jenkins-github/
from kyle.hewitt@ngc.com to All Participants:
mvn archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false
#Testing my ssh keys on WLS
#Check Java version
java -version
****Optional****** 
#Gitlab Setup https://about.gitlab.com/install/#ubuntu
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl -y
sudo apt-get install -y postfix
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
sudo apt install gitlab

cat /etc/gitlab/initial_root_password
```

## Jenkins Setup

### Add their key

```bash
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add
```

### Add their repo

```bash
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
#Please note: using this repo will result in the following message:
	#does not have a Release file.
	#N: Updating from such a repository can't be done securely, and is therefore disabled by #default.
	#N: See apt-secure(8) manpage for repository creation and user configuration details.
```

### Recommend using the following

```bash
curl -fsSL -k https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install jenkins
sudo service jenkins status
```

### login

```bash
http://localhost:8080
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Install GIT and Maven into Jenkins Plugins

Maven Integration
Git Plugin

### Setup Global Tool Configuration

#### Maven data

```text
mvn -version
Java version: 1.8.0_292, vendor: Private Build
Java home: /usr/lib/jvm/java-8-openjdk-amd64/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "4.4.0-1126-aws", arch: "amd64", family: "unix"
```

### Manage Jenkin -> Global Tool Configuration

#### Add JDK - do not use install automatically

```text
Name= local_jdk
JAVA_HOME = /usr/lib/jvm/java-8-openjdk-amd64/
```

#### Add Git

```text
name= local_git
path= /usr/bin/git
```

#### Add Maven

```text
name= local_maven
path= /usr/share/maven
```

****Optional******

#### Add Gradle

```text
name= local_gradle
path= /usr/bin/gradle
```

## Norw from kyle.hewitt@ngc.com to All Participants

git push doesn't work unless you've specified an upstream reference for the branch you're on. You can configure git to automatically set that upstream reference when you create a new branch but by default that's not configured. So if you go and say git push it might say idk what you want me to do. The reason for this is you can have more than one upstream reference if you want to have a codebase that's hosted on both a home hosted server and a enterprise hosted one to give you an additional level of permission control or if you don't have access to the "truth" repo
from kyle.hewitt@ngc.com to All Participants:
so by default you have to use git push origin <branch.name>
from Sharique Kamal to All Participants:
typically it would default to "git push origin master"
from kyle.hewitt@ngc.com to All Participants:
git push --set-upstream <remote> <branch>
from kyle.hewitt@ngc.com to All Participants:
git config --global alias.pushd "push -u origin HEAD"
from kyle.hewitt@ngc.com to All Participants:
git branch -a will list remote branches not local to your system
from Sharique Kamal to All Participants:
git pull ==> git fetch+git merge
from kyle.hewitt@ngc.com to All Participants:
in order to avoid having to enter your credentials on git every time you do a command that requires communication with the remote server you can run this command and then next time you provide your credentials it will save them 
from kyle.hewitt@ngc.com to All Participants:
git config --global credential.helper store
from kyle.hewitt@ngc.com to All Participants:
Be careful using this though, because it will just save your password as base64 encoded plain text string in your .gitconfig file so its not secure. SSH is always the recommended whenever possible