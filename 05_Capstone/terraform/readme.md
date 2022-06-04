# Environment Setup using Terraform

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

[Instruction source:](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

### Define a new user for AWS account

In order to interact with the AWS Application Programming Interface (API) through the Terraform command line tool, you will need to have available a properly define user account.

The values provided by the class lab do not work and to be successful, you will need to create a new user for credential based support.  

Use the Practice Labs provided interface to access the AWS Web Console.  Open the Auth URL in a new tab to arrive a the AWS Management console.  In my case this was URL <https://us-east-1.console.aws.amazon.com/console/home?region=us-east-1>#.
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

## Define the terraform configuration

### main.tf

### main_script

