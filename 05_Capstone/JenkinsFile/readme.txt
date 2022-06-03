The file config.xml needs to be placed in the subdirectory ./jobs/CapstoneProject under the Jenkins home directory.
Defined in HOME env var i.e. HOME=/var/lib/jenkins for the Jenkins user
i.e. /var/lib/jenkins/jobs/CapstoneProject

The Pipeline Script is currently embedded in the config.xml for ease of testing.

The second config file, config2.xml, has the definition if we want to call out to the 
seperate JenkinsFile "CapstoneBuildTestDockerDeploy" 



