# Capstone Project Option 3 B-Safe

## Project Description

Create a CI/CD Pipeline to convert the legacy development process to a DevOps process.
Background of the problem statement:
A leading US healthcare company, Aetna, with a large IT structure had a 12-week release cycle and their business was impacted due to the legacy process. To gain
true business value through faster feature releases, better service quality, and cost optimization, they wanted to adopt agility in their build and release process.
The objective is to implement iterative deployments, continuous innovation, and automated testing through the assistance of the strategy.
Implementation requirements:

1. Install and configure the Jenkins architecture on AWS instance
2. Use the required plugins to run the build creation on a containerized platform
3. Create and run the Docker image which will have the application artifacts
4. Execute the automated tests on the created build
5. Create your private repository and push the Docker image into the repository
6. Expose the application on the respective ports so that the user can access the deployed application
7. Remove container stack after completing the job

The following tools must be used:

1. EC2
2. Jenkins
3. Docker
4. Git

The following things to be kept in check:

1. You need to document the steps and write the algorithms in them.
2. The submission of your Github repository link is mandatory. In order to track your tasks, you need to share the link of the repository.
3. Document the step-by-step process starting from creating test cases, the executing it, and recording the results.
4. You need to submit the final specification document, which includes:

   * Project and tester details
   * Concepts used in the project
   * Links to the GitHub repository to verify the project completion
   * Your conclusion on enhancing the application and defining the USPs (Unique Selling Points)

## Project Goal

Develop an automated pipeline for a legacy application to build, test, and deploy the application.  

### Environment

* Jenkins instance properly configured in AWS
* Jenkins baseline
* Plugins
  * Pipeline Groovy
  * Pipeline Shared Groovy Libraries
  * Docker
  * Git
* Private Docker repository
* Execution environment
  * Docker installed
  * JDK 11+
  * Maven 5.4+
* Source SCM
  * Existing legacy project [RetailOne](https://github.com/bailey572/devops/tree/main/05_Capstone/docker/sampleTest/RetailWebApp)

#### Environment Setup

The environment is defined utilizing a Terraform script to create a Virtual Private Cloud (VPC) consisting of

* A gateway to allow external access and obtain a public IP address
* A Build host Host configured with
  * Docker installation
  * A Local Docker registry configured
  * Required build tool chain
* A Jenkins instance configured with the plugins
  * Pipeline Groovy
  * Pipeline Shared Groovy Libraries
  * Docker
  * Git
  * Credentials
* Internal subnet
* AWS key pair exchange
* An execution host for the deployed container

### Pipeline

This will be accomplished leveraging a Jenkins instance that will:

* Be executed on demand
  * Manual execution
  * SCM polling
* Dynamically create a build/test container
  * Configured build environment
  * Application source and test code
  * Port access to monitor and log results
* Push image to private docker repository
* Build the application within the container
* Capture build results
* Execute the Unit test associated with the application
* Capture Unit test results
* Remove build/test container

## Project Setup

As this is a proof of concept meant to flush out the environment and pipeline definitions, the selection of a project was of low importance.  For ease of use and implementation, a pre-existing Retail Web Application with existing front end and test cases was selected.
The build, test execution, and packaging are controlled through single [pom](https://github.com/bailey572/devops/blob/main/05_Capstone/docker/sampleTest/RetailWebApp/pom.xml) file.
For additional information on this project, please refer to the [Readme](https://github.com/bailey572/devops/tree/main/05_Capstone/docker/sampleTest/RetailWebApp#readme) to manually build and execute the application locally.

## Docker Setup

In order to easily manage and deploy the webapp, and to conform to the project requirements, a dockerfile was created to host the war file inside a container running a webserver instance.
Again, as this a proof of concept, a simple solution was leveraged with an existing Tomcat docker image is used that simply copies in the built war file and exposes the ports.  The definition of this image is contained in the [DockerFile](https://github.com/bailey572/devops/blob/main/05_Capstone/docker/Dockerfile)
For additional information on this project, please refer to the [Readme](https://github.com/bailey572/devops/blob/main/05_Capstone/docker/readme.md) to manually build the image and execute a local container.

## Pipeline Setup

Execution of this project is accomplished through a Jenkins Pipeline configuration leveraging a Groovy based Pipeline script.  The Jenkins job is defined as:

* Name - Capstone Project
* Do not build concurrent builds
* GitHub project
  * url - [RetailWebApp](https://github.com/bailey572/devops/tree/main/05_Capstone/sampleTest/RetailWebApp)
* Preserve stashes for completed builds
  * Number of stashes == 1
* Build Triggers - Poll SCM
* Pipeline Script - CapstoneBuildTestDockerDeploy

For a full definition, please refer to the [CapstoneProject](https://github.com/bailey572/devops/blob/main/05_Capstone/JenkinsFile/config.xml) definition itself which contains stages:

* Get the code
* Build the code
* Run the tests
* Package the Webapp
* Build the image
* Verify local registry
* Push to local registry
* Deploy container

Alternatively, this project can also be executed from the [CapstoneProject2](https://github.com/bailey572/devops/blob/main/05_Capstone/JenkinsFile/config2.xml) definition, which performs that same tasks but leverages a JenkinsFile instead on embedding the pipeline directly.

For additional information on this Jenkins project, please refer to the [Readme](https://github.com/bailey572/devops/blob/main/05_Capstone/JenkinsFile/readme.md) for instructions on manually deploying the configuration to a Jenkins instance.

## Infrastructure as Code Environment Setup

Definition of this project is accomplished through Infrastructure as Code (IaC), leveraging a Terraform configuration targeting Amazon Web Services (AWS).  The Terraform configuration deploys an infrastructure consisting of an AWS hosted platform defined within through the [main](https://github.com/bailey572/devops/blob/main/05_Capstone/terraform/main.tf) file.  This file leverages [installJenkins.sh](https://github.com/bailey572/devops/blob/main/05_Capstone/terraform/installJenkins.sh) for the configuration of the Jenkins instance to include the installation of the pipeline defined in [CapstoneBuildTestDockerDeploy](https://github.com/bailey572/devops/blob/main/05_Capstone/JenkinsFile/config.xml).

Detailed explanation of this configuration, setup, and usage are contained within the Terraform [ReadMe](https://github.com/bailey572/devops/blob/main/05_Capstone/terraform/readme.md) but consists of the following basic steps:

* Setting up developer Terraform environment
* Defining the Terraform configuration
* Terraform components
* Shutdown and Cleanup

## Finalize the Jenkins Instance

Even though the Jenkins instance is created and dependencies are installed, I have not found a way around the default Jenkins screen and you will need to log onto the web interface to do so.  Since we will already be in Jenkins, this in an opportune time to verify the pipeline project functionality.  To do so, you will need to access the Jenkins instance through both the web interface and the command line.

### Jenkins Command Line

The command line can be accessed either through the aws console or through your local system.  While you could just use the IP provided at the end of **apply** job, the easiest way is through the web interface for your credentials.  Navigate to the AWS, EC2, Instances page, this [link](https://us-east-1.console.aws.amazon.com/ec2) may work for you.  If not, start at the Simplilearn Practice Lab page and follow the instructions for creating a new user in the Terraform [ReadMe](https://github.com/bailey572/devops/blob/main/05_Capstone/terraform/readme.md) file.

Once you have navigated to the EC2 instances, find the running **JenkinsServer** instance, select its name, and click the enabled **Connect** widget.  This will display a page that will allow you to select one of four choices.

* EC2 Instance connect - provides a web based console that will be opened in a new tab
* SSH client - will display the credentials needed to access through a local terminal

Through either method, you will need to acquire the autogenerate key to access Jenkins by issuing ```sudo cat /var/lib/jenkins/secrets/initialAdminPassword```.

This will display the key you will need to paste into the GUI instance on first run.

### Jenkins Graphical User Interface

To access the Jenkins GUI, open a web browser and paste the IP printed out at the end of the **Apply** run with the port 8080 appended.

```bash
Example:
http://44.206.220.61:8080
```

This will display the Jenkins interface prompting you for the key to access Jenkins.  Paste in the value and continue.
Jenkins will then ask you about installing plugins.  Either option that you select will not impact our current installation as we have already installed all needed plugins during construction of the instance.  Selecting the manual option and cancelling is the quickest way but again, either works.

You are also able to define a user at this  point or skip.  An additional user is not required and can be skipped.  Just keep going until you eventually make it to the Jenkins Dashboard.

### Verify Pipeline

While the configuration will execute based on SCM polling for changes, for initial testing it is recommended that manual testing should occur.

Once you have made your way to the Jenkins Dashboard, select the **Capstone5** project name.

Because I failed to figure out how to dynamically assign an IP or reach out to the WarHost instance, you will need to manually update the Jenkins Pipeline prior to running it to enable public access to the container.  From the **Capstone5** project, select Configure, scroll down to the Pipeline syntax, and then replace line 64's localhost text with the current machines internal IP address.

```bash
Example Line 64 Edit:
sh "docker run -d -p localhost:80:8080 $registry:$BUILD_NUMBER "
sh "docker run -d -p 10.0.61.80:80:8080 $registry:$BUILD_NUMBER "
```

Select save and then select the Build now link.

This will start the pipeline manually and run the steps:

* Get the code
* Build the code
* Run the tests
* Package the Webapp
* Build the image
* Verify local registry
* Push to local registry
* Deploy container from docker image

For detailed information about this pipeline configuration, please refer to the [Pipeline](https://github.com/bailey572/devops/blob/main/05_Capstone/JenkinsFile/config.xml) and [ReadMe](https://github.com/bailey572/devops/blob/main/05_Capstone/JenkinsFile/readme.md).

## Verify the Application

Now that we have a functioning pipeline, the container from our built image should be available through the web interface.  To verify its existence, open a web page using the IP address with the web application name appended.

```bash
Example: http://35.171.62.123/retailone/
```

Please note, this is running on port 80 but as that is the default for http, it is not necessary to specify the port.

For further information on running the web application, please refer to the applications [ReadMe](https://github.com/bailey572/devops/blob/main/05_Capstone/docker/sampleTest/RetailWebApp/ReadMe.md) file.

## Conclusion and Thoughts

Need to figure out how to push container to another node 10.0.61.80:80->8080

While this project meets the requirements of the capstone project outline, captured above, I hope that I misunderstood the Jenkins requirement deployment on an AWS.  My first thought was that we were to create an EC2 instance, configure Jenkins, and then execute a pipeline but since any instance I created disappeared after 4-8 hours, this was not a tenable solution.  Instead, I created a Terraform script to create the Jenkins instance and used remote-exec to accomplish the configurations since this account does not appear to allow me to store an image.

Another thought, and if I was doing this for real, I would change a few items

* Store the images in a static repository
* Deployed the container into a Kubernetes or similar cluster
* Published the Pipeline results to a status board
