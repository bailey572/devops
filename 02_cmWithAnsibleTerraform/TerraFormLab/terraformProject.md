# Deploy Wordpress to AWS Terraform

## Install Terraform

Instruction source: https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
terraform -install-autocomplete
```

## Install AWS CLI

Instruction source: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html 

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

## Define a new user for AWS account

The values provided by the class lab do not work.  Need to create a new user.  Use the lab version to access the AWS Management console:
https://us-east-1.console.aws.amazon.com/console/home?region=us-east-1#

Then access Identity and and Access Management (IAM) https://console.aws.amazon.com/iam/home?region=us-east-1

Select the Users link and then Add Users

```bash
User Name = administrator
AWS credential type = Access key - Programmatic access
Group = Administrator
Add tags = next "no value"
Review = Create user
```

Save the data before leaving.  You will need it later down.
Access Key ID [****************UR3P]: AKIAVYN6NT36QMH2H3HD
Secret Access Key [****************PDd+]: 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

## Define the terraform configuration

Righteously stolen from https://www.devbhusal.com/using-terraform-to-automate-wordpress-installation-with-aws-ec2-instance-and-rds/
Paste in the following to main.tf
nano main.tf

```GO

```

## Initialize and run

```bash
terraform init
touch ssh_key.private

aws configure
AWS Access Key ID [****************UR3P]: AKIAVYN6NT36QMH2H3HD
AWS Secret Access Key [****************PDd+]: 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
Default region name [us-east-1]: us-east-1
Default output format [None]: 

terraform plan -var-file="user.tfvars"
terraform validate -var-file="user.tfvars"
terraform apply
yes
```

Once done head back to AWS Web Console website and look under the EC2 instances.  Use search bar and find EC2.
https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#Instances:
Under the EC2 instance connect, you will see the IP address.  You can use this to see you instance through the web browser of sss.  My IP was 34.204.215.126 so:
ssh -i ssh_key.private ec2-user@34.204.215.126
http://52.201.173.3/

Site Title: Initial Test
UserName: joebob
Password: sjFQd#o*OZYf06dPre
Email: bailey572@msn.com

To make and apply changes to the tf file, you will need to use:

```bash
terraform destroy
terraform apply
```
