# DevOps Program 4.1, Course 2, Project 2

## Deployment of WordPress EnvironmentDeployment of WordPress Environment

DESCRIPTION

You are a DevOps engineer at XYZ Ltd. Your company is working mostly on WordPress projects. A lot of development hours are lost to perform WordPress setup with all dependencies like PHP, MySQL, etc. The Company wants to automate it with the help of a configuration management tool so that they can follow a standard installation procedure for WordPress and its components whenever a new requirement or client comes in. The below mentioned components should be included:

- PHP
- Nginx/Apache Web Server
- MySQL
- WordPress

**Steps to Perform:**

1. Establish configuration management master connectivity with WordPress server
2. Validate connectivity from master to slave machine
3. Prepare IaaC scripts to install WordPress and its dependent components
4. Execute scripts to perform installation of complete WordPress environment
5. Validate installation using the public IP of VM by accessing WordPress application

Based on the content of the class, my initial assumption was the we were expected to use a tool such as Terraform to form the foundational infrastructure as code and then perform final configuration using Ansible.  Based on research, I do not believe that this is required for a successful execution and this document captures the steps necessary to execute the required steps.

## Prepare the Development Environment

For successful execution, the operators environment must be properly configured Terraform and AWS dependencies and the project area must be configured.  The following steps assume the operator is working from an x86-64 based system running Ubuntu version 18 or above.

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

Please note: Terraform autocomplete is not required but a useful utility.

Instruction source: https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started

### Install AWS CLI

Installation of Amazons Web Service (AWS) Command Line Interface (CLD) is accomplished following the manufacturers supplied instructions.  For further details, please refer to the Instruction Source.
For a quick install, simply follow the following steps.

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

Instruction source: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
### Define a new user for AWS account

In order to interact with the AWS Application Programming Interface (API) through the Terraform command line tool, you will need to have available a properly define user account.

The values provided by the class lab do not work and to be successful, you will need to create a new user for credential based support.  

Use the Practice Labs provided interface to access the AWS Web Console.  Open the Auth URL in a new tab to arrive a the AWS Management console.  In my case this was URL https://us-east-1.console.aws.amazon.com/console/home?region=us-east-1#.
Select All services to expand the list of options and select the AWS Identity and Access Manager (IAM)
Select Users link (left side) and then the Add Users link (top right corner)
Use the following values to walk through the wizard.

```bash
User Name = administrator
AWS credential type = Access key - Programmatic access
Group = Administrator
Add tags = next "no value"
Review = Create user
```

At successful completion, remember to save the authentication data before leaving.  You will need it for the CLI configuration.
Access Key ID [****************UR3P]:
Secret Access Key [****************PDd+]:

## Define the terraform configuration

This project is focused on Infrastructure as Code (IaaC) and was implemented through multiple web searches, glorious leveraging of existing code examples, and customization and documentation for our purpose.  I would like to make special note of the foundational work provided by Dev Bhusal, acquired from [Using Terraform to Deploy WordPress with AWS EC2 instance and RDS](https://www.devbhusal.com/using-terraform-to-automate-wordpress-installation-with-aws-ec2-instance-and-rds/).

For this project, you will need to access the files contained in [TerraFormLab](https://github.com/bailey572/devops/tree/main/02_cmWithAnsibleTerraform/TerraFormLab) consisting of the following files.

- .gitignore (to ensure terraform and ssh keys are not committed)
- main_script.tf (main terraform configuration file)
- terraform.tfvars (collection of variables to define aws environment)
- terraformProject.md (this document)
- user_data.tpl (template file for installation of Wordpress)
- user.tfvar (variable for database password)
- variables.tf (template file to declare/leverage variables)

clone or copy these files into a new working directory from [TerraFormLab](https://github.com/bailey572/devops/tree/main/02_cmWithAnsibleTerraform/TerraFormLab)

## Initialize Environment

### Terraform work area

From the console, change to the TerraFormLab working directory and initialize the environment with the following commands.

```bash
terraform init
```

### AWS authentication

This initializes the directory for Terraform tracking.  Once complete, configure AWS CLI access using the authentication data for the new user created above.  From the same directory issue:

```bash
aws configure
AWS Access Key ID [****************UR3P]: 
AWS Secret Access Key [****************PDd+]: 
Default region name [us-east-1]: us-east-1
Default output format [None]: 
```

Please note, depending on how long you go between steps and your AWS subscription, you may need to get new credentials.
### Generate SSH Key Pairs

For internal, password less ssh access, we will generate a key pair (mykey-pair) and add to our instances on apply.  From the same directory issue:

```bash
ssh-keygen -f mykey-pair
```

Don't panic, the .gitignore file will keep you from committing these keys but it is best to store them elsewhere.  Please note, if you do so now, you will need to update the main_script.tf file.

## Execute the Plan

Prior to execution, verify the preferred region for AWS hosting.  For this class, we are hosting on us-east and region/zones are set to us-east-1.  Check your AWS account configuration and make appropriate modifications to the terraform.tfvars file for the following variables:

```go
region       = "us-east-1"      //USA region
AZ1          = "us-east-1a"     // for EC2
AZ2          = "us-east-1b"     //for RDS 
AZ3          = "us-east-1c"    //for RDS
```

If you want to change the password for the database user, modify hte user.tfvars file as well.

Once complete, we just need to plan, validate the plan, and then apply the plan.

```bash
terraform plan -var-file="user.tfvars"
terraform validate 
terraform apply -var-file="user.tfvars"
```

During the apply operation, you will need to specify 'yes' to confirm the creation of the resources. Sit back and watch as terraform goes to work creating the AWS resources.

```bash
tls_private_key.example: Creating...
aws_key_pair.mykey-pair: Creating...
aws_vpc.test-env: Creating...
aws_vpc.test-env: Still creating... [10s elapsed]
aws_internet_gateway.test-env-gw: Creating...
aws_subnet.test-subnet-private-2: Creating...
aws_subnet.test-subnet-public-1: Creating...
aws_subnet.test-subnet-private-1: Creating...
aws_security_group.ec2_allow_rule: Creating...
aws_route_table.test-public-crt: Creating...
aws_db_subnet_group.RDS_subnet_grp: Creating...
aws_security_group.RDS_allow_rule: Creating...
aws_route_table_association.test-crta-public-subnet-1: Creating...
aws_security_group.RDS_allow_rule: Still creating... [10s elapsed]
aws_security_group.RDS_allow_rule: Creation complete after 11s [id=sg-05656af8b9171893e]
aws_db_instance.wordpressdb: Creating... 
aws_instance.wordpressec2: Creating.
Wordpress_Installation_Waiting: Creating...
...
Apply complete! Resources: 16 added, 0 changed, 0 destroyed.

Outputs:

INFO = "AWS Resources and Wordpress has been provisioned. Go to http://34.207.18.39"
IP = "34.207.18.39"
RDS-Endpoint = "terraform-20220319153903574000000004.cgzcsyaqnbmc.us-east-1.rds.amazonaws.com:3306"
```

Once done, the instance is ready for access.  To do so, access the public wordpress instance provided by the INFO output ```INFO = "AWS Resources and Wordpress has been provisioned. Go to http://34.207.18.39"``` through a web browser.  This will lead you to the administrator configuration wizard of wordpress.

To see the full depoyment, use the AWS Web Console website and look under the EC2 instances.  This can be found through the search bar by looking for EC2.  For me, the URL is [EC2](
https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#Instances:)

Once you locate the instances ID, view the configuration details.  Selecting the Instance ID will provide several tabs.

- Details - will show that the platform is Linux/Unix and the Key pair is present
- Security - shows the security group rules defined in main_script.tf
  - sgr-0a4bd5514604815ee	22	TCP	0.0.0.0/0	terraform-20220319153845641100000001
  - sgr-0723d70b9ad114b7a	3306	TCP	0.0.0.0/0	terraform-20220319153845641100000001
  - sgr-0dc33464fbb0aaed0	443	TCP	0.0.0.0/0	terraform-20220319153845641100000001
  - sgr-0d82595d032e08f80	80	TCP	0.0.0.0/0	terraform-20220319153845641100000001
- Network - shows the VPC and Subnet defined in main_script.tf
- Storage - Displays our data allocation size of 8 GiB

To connect directly, to the instance, select the Connect icon and use the EC2 Instance Connect. This will log you into a web based terminal where you can see the installation of php and httpd through ```systemctl status```.
For specifics on the WordPress intallation, review the wp-config.php file to see the database connection ```cat /var/www/html/wp-config.php | more```

To make and apply changes to the tf file, you will need to use:

```bash
terraform destroy
terraform apply
```
