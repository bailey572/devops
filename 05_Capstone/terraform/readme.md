# Jenkins Terraform Environment

## Environment Setup using Terraform

For successful execution, the operators environment must be properly configured Terraform and AWS dependencies and the project area must be configured.  The following steps assume the operator is working from an x86-64 based system running Ubuntu version 18 or above as either a local client or a VM.

### Install Terraform

Installation of HashiCorps Terraform is accomplished following the manufacturers supplied instructions.  For further details, please refer to the Instruction Source.
For a quick install, simply follow the following steps.

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
terraform -install-autocomplete
```

```terraform --version``` can be used as a quick test to verify installation.

Please note: Terraform autocomplete is not required but a useful utility.

[Instruction source:](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)

### Install AWS CLI

Installation of Amazons Web Service (AWS) Command Line Interface (CLD) is accomplished following the manufacturers supplied instructions.  For further details, please refer to the Instruction Source.
For a quick install, simply follow the following steps.

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

```aws --version``` can be used as a quick test to verify installation.

[Instruction source:](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

### Define a new user for AWS account

In order to interact with the AWS Application Programming Interface (API) through the Terraform command line tool, you will need to have available a properly define user account.

The values provided by the class lab do not work and to be successful, you will need to create a new user for credential based support.  

Use the Practice Labs provided interface to access the AWS Web Console.  This will generally require logging into SimpliLearn, going to the G-DO---Configuration-Management-with-Ansible-and-Terraform/practice-labs and starting a lab instance.  Open the **Auth URL** in a new tab to arrive a the AWS Management console.

In my case this was URL <https://us-east-1.console.aws.amazon.com/console/home?region=us-east-1>#.

Select **All services** to expand the list of options and select the AWS Identity and Access Manager **(IAM)**
Select Users link (left side) and then the Add Users link (top right corner)
Use the following values to walk through the wizard.

```bash
User Name = administrator
AWS credential type = Access key - Programmatic access
Group = Administrator - SysAdmin
Add tags = next "no value"
Review = Create user
```

At successful completion, remember to save the authentication data before leaving.  You will need it for the CLI configuration.

* Access Key ID [****************UR3P]:
* Secret Access Key [****************PDd+]:

## Initialize Environment

### Terraform work area

From the console, change to the ./05_Capstone/terraform directory and initialize the environment with the following commands.

```bash
terraform init
```

This command processes the main.tf file currently in the directory, does an initial evaluation, creates local resource .terraform.lock.hcl to manage the configuration, and pulls down resource (plugins) defined in the main.tf file.  Since we are targeting AWS, one of the plugins downloaded will be ./hashicorp/aws.

### AWS authentication

Before we can actively communicate with the AWS, we need to provide authentication data for the new user created above through the AWS web client.  From the same directory issue:

```bash
aws configure
AWS Access Key ID [****************UR3P]: YOUR_KEY_ID_HERE
AWS Secret Access Key [****************PDd+]: YOUR_SECRET_KEY_HERE
Default region name [us-east-1]: us-east-1
Default output format [json]: 
```

Please note, depending on how long you go between steps and your AWS subscription, you may need to get new credentials.

### Generate SSH Key Pairs

For internal, password less ssh access, we will generate a key pair (mykey-pair) and add to our instances on apply.  From the same directory issue:

```bash
ssh-keygen -f mykey-pair
```

Don't panic, the .gitignore file will keep you from committing these keys but it is best to store them elsewhere.  Please note, if you do so now, you will need to update the main_script.tf file.

## Defining the Terraform configuration

The Terraform configuration is captured in the [main.tf](https://github.com/bailey572/devops/blob/main/05_Capstone/terraform/main.tf) file and leverages the [installJenkins.sh](https://github.com/bailey572/devops/blob/main/05_Capstone/terraform/installJenkins.sh) for the configuration of the Jenkins instance.  Since it is already defined, we simply need to verify its configuration and deploy using Terraform supplied tools.

### Plan

 The command ```terraform plan``` generates a **speculative** execution plan, showing what actions Terraform would take to apply the current configuration. This command does not actually perform the planned actions but acts like a compiler and initialization step.  The main.tf file is processed sequentially and stops processing on any error found requiring an update and rerun for each error until a successful run is accomplished.

 For this configuration, the most likely error a user would run into may the generated ssh key file generated during setup and a successful run will list the actions that are **planned** for execution i.e. the creation of

* aws_eip.eip - Elastic Ineternet Protocol for EC2
* aws_instance.JenkinsServer - Machine instance to host Jenkins
* aws_internet_gateway.test-env-gw - Gateway for managing traffic
* aws_key_pair.mykey-pair - Password less ssh keys
* aws_route_table.test-public-crt - AWS Common Runtime Libraries accessor
* aws_route_table_association.test-crta-public-subnet-1 - Associate route tabLe to public subnet
* aws_security_group.ec2_allow_rule - Firewall rules for public access
* aws_subnet.test-subnet-public-1 - Public subnet network definition
* aws_vpc.test-env - Definition of the Virtual Private Cloud (VPC)
* null_resource.Jenkins_Installation_Waiting - Installation handler for the Jenkins service
* tls_private_key.example - Enforce AWS encrypted communication using Transport Layer Security

From the ./05_Capstone/terraform directory, issue the command ```terraform plan``` and verify the successful processing of the above resources.

### Validate

The command ```terraform validate```  verifies only the local configuration and does not access any remote services such as remote state, provider APIs, etc.  Validate runs checks that verify whether a configuration is syntactically valid and internally consistent, regardless of any provided variables or existing state and is primarily useful for general verification of reusable modules, including correctness of attribute names and value types.

From the ./05_Capstone/terraform directory, issue the command ```terraform plan``` and verify the configuration is valid.

### Apply

The final step, and actual deployment is invoked through the ```terraform apply``` command.  This creates or updates the infrastructure according to the Terraform configuration files in the current directory.

From the ./05_Capstone/terraform directory, issue the ```terraform apply``` command.  This will generate output similar to ```terraform plan``` but contains the actual values that will be used on the AWS instance. To perform the actions, type **yes** when prompted to deploy to AWS and create the infrastructure.

Upon completion, the IP addresses of the new instances are output.  Use the Jenkins_IP for the next step.

#### Apply Notes

Executing ```terraform apply``` additional times will results in the teardown and build up of the infrastructure but will not always invoke the remote-exec provisioners use to install our services.  

For a simple ```terraform apply``` it will create new machines using the same IP addresses, but if you have used ssh to access the system you will need to flush the known host file to keep from getting a security warning.

```bash
ssh-keygen -f ~/.ssh/known_hosts -R "ec2-44-206-204-6.compute-1.amazonaws.com"
ssh -i ~/.ssh/mykey-pair ec2-user@ec2-44-206-204-6.compute-1.amazonaws.com
```

For a full deployment, to include forced execution of the remote-exec provisioners, issue  ```terraform destroy``` and then  ```terraform apply```.  This will ensure a complete teardown and build.

That's it.  The Terraform environment is all setup.
