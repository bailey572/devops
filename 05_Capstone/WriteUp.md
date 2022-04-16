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

* Jenkins instance properly configured
* Jenkins baseline
* Plugins
  * Pipeline Groovy
  * Pipeline Shared Groovy Libraries
  * Docker
  * Git
* Private Docker repository
* Execution environment
  * Docker installed
  * .NET Core SDK
  * Mono environment
* Source SCM
  * Existing legacy project

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

These are optional steps if we want to go that far but would require a second pipeline that we could string together

* Remove current application container instance
* Dynamically create new application container
  * Configured run environment
  * Deployed application
  * Port access to application
