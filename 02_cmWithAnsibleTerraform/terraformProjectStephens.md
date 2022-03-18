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

## Initialize 
Paste in the following to main.tf
nano main.tf

```json
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

variable "key_name" {}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_vpc" "test-env" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_internet_gateway" "test-env-gw" {
  vpc_id = "${aws_vpc.test-env.id}"
}

resource "aws_security_group" "ingress-all-test" {
name = "allow-all-sg"
vpc_id = "${aws_vpc.test-env.id}"
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
from_port = 22
    to_port = 22
    protocol = "tcp"
  }
// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_subnet" "subnet-uno" {
  cidr_block = "${cidrsubnet(aws_vpc.test-env.cidr_block, 3, 1)}"
  vpc_id = "${aws_vpc.test-env.id}"
  availability_zone = "us-east-1a"
}

resource "aws_route_table" "route-table-test-env" {
  vpc_id = "${aws_vpc.test-env.id}"
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test-env-gw.id}"
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.subnet-uno.id}"
  route_table_id = "${aws_route_table.route-table-test-env.id}"
}

resource "aws_instance" "main_instance" {
  ami           = "ami-08e4e35cccc6189f4"
  instance_type = "t2.micro"
  key_name = aws_key_pair.generated_key.key_name
  security_groups = ["${aws_security_group.ingress-all-test.id}"]
  subnet_id = "${aws_subnet.subnet-uno.id}"

  tags = {
    Name = "MainVM"
  }
  
  provisioner "local-exec" {
    command = "grep \"private_key_pem\" terraform.tfstate | sed 's/\\\\n/\\n/g' | head -n -1 | tr \"\\\"\" \"\\n\" | tail +4 > ssh_key.private  ; chmod 600 ssh_key.private"
  }
}


resource "aws_eip" "ip-test-env" {
  instance = "${aws_instance.main_instance.id}"
  vpc      = true
}

resource "null_resource" "install_packages" {

  
  provisioner "remote-exec" {
    
    inline = [
    "sudo yum -y install java-1.8.0-openjdk-devel",
    "sudo yum -y install python3",
    "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
    "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
    "sudo yum -y install jenkins-2.19.3-1.1 --nogpgcheck",
    "sudo systemctl daemon-reload"
    ]
 
  connection {
      type        = "ssh"
      host        = "${aws_eip.ip-test-env.public_ip}"
      user        = "ec2-user"
      private_key = file("ssh_key.private")
      timeout     = "10m"
   }
   }
}

```

Now spin this sucker up

```bash
terraform init
touch ssh_key.private

aws configure
AWS Access Key ID [****************UR3P]: AKIAVYN6NT36QMH2H3HD
AWS Secret Access Key [****************PDd+]: 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
Default region name [us-east-1]: us-east-1
Default output format [None]: 

terraform validate
terraform apply
yes
```

Once done head back to AWS Web Console website and look under the EC2 instances.  Use search bar and find EC2.
Under the EC2 instance connect, you will see the IP address.  You can use this to see you instance through the web browser of sss.  My IP was 34.204.215.126 so:
ssh -i ssh_key.private ec2-user@34.204.215.126
http://34.204.215.126:8080
