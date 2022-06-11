terraform {
   // Specify provided translator
  required_providers {
    aws = {
      source  = "hashicorp/aws" // we are using AWC
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

// Define our provider for resources
provider "aws" {
  profile = "default"
  region  = "us-east-1"  // our account allows for us-east-1 or us-east-2 farms
}

// resource keyword defines infrastructure objects

// Generates a secure private key and encodes it as Privacy Enhanced Mail (PEM. )
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// Defines the Virtual Private Cloud (VPC)
resource "aws_vpc" "test-env" {
  cidr_block = "10.0.0.0/16" // Classless Inter-Domain Routing
  enable_dns_hostnames = true
  enable_dns_support = true
}

// Create Public Subnet for Amazon Elastic Compute Cloud (EC2)
resource "aws_subnet" "test-subnet-public-1" {
  vpc_id                  = "${aws_vpc.test-env.id}"
  cidr_block              = "${cidrsubnet(aws_vpc.test-env.cidr_block, 3, 1)}"
  map_public_ip_on_launch = "true" //it makes this a public subnet so others can access it
  availability_zone       = "us-east-1a"

}

// Define the gateway to allow external access and obtain a public IP address
resource "aws_internet_gateway" "test-env-gw" {
  vpc_id = "${aws_vpc.test-env.id}"
}

// Create a Routing table 
resource "aws_route_table" "test-public-crt" {
  vpc_id = "${aws_vpc.test-env.id}"

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.test-env-gw.id
  }
}

// Associating route tabLe to public subnet
resource "aws_route_table_association" "test-crta-public-subnet-1" {
  subnet_id      = aws_subnet.test-subnet-public-1.id
  route_table_id = aws_route_table.test-public-crt.id
}

// A security group that defines network traffic
resource "aws_security_group" "ec2_allow_rule" {

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "JENKINS"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  vpc_id = "${aws_vpc.test-env.id}"
  tags = {
    Name = "allow ssh,http,https"
  }
}

// Create Amazon Elastic Compute Cloud (Amazon EC2)
resource "aws_instance" "JenkinsServer" {
  ami             = "ami-0022f774911c1d690"// "ami-08e4e35cccc6189f4"
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.test-subnet-public-1.id
  security_groups = ["${aws_security_group.ec2_allow_rule.id}"]
  key_name        = aws_key_pair.mykey-pair.id
  tags = {
    Name = "JenkinsServer"
  }
}

resource "aws_instance" "WarHost" {
  ami             = "ami-0022f774911c1d690"// "ami-08e4e35cccc6189f4"
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.test-subnet-public-1.id
  security_groups = ["${aws_security_group.ec2_allow_rule.id}"]
  key_name        = aws_key_pair.mykey-pair.id
  tags = {
    Name = "WarHost"
  }
}

// Sends your public key to the instance. The key pair is used to control login access to EC2 instances.
resource "aws_key_pair" "mykey-pair" {
  key_name   = "mykey-pair"
  public_key = file("./mykey-pair.pub")
}

// creating Elastic IP for EC2
resource "aws_eip" "Jenkinseip" {
  instance = aws_instance.JenkinsServer.id
}
resource "aws_eip" "Warip" {
  instance = aws_instance.WarHost.id
}

// Output handy messages to the builder
output "Jenkins_IP" {
  value = aws_eip.Jenkinseip.public_ip
}
output "WAR_IP" {
  value = aws_eip.Warip.public_ip
}

// configure provisioners that are not directly associated with a single existing resource i.e. wordpress
// This resource will install the Jenkins host dependencies 
resource "null_resource" "Jenkins_Installation_Waiting" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./mykey-pair")
    host        = aws_eip.Jenkinseip.public_ip
  }

  //copy the installation script
  provisioner "file" {
    source = "installJenkins.sh"
  	destination = "/tmp/installJenkins.sh"
  }
 
  //run the installer
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installJenkins.sh",
	  "sudo /tmp/installJenkins.sh"
	  ]
  }

   //copy the installation script
  provisioner "file" {
    source = "installPlugins.sh"
	  destination = "/tmp/installPlugins.sh"
  }
 
  //run the installer
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installPlugins.sh",
	    "sudo /tmp/installPlugins.sh"
	  ]
  }
}
// This resource will install the WAR host dependencies 
resource "null_resource" "WAR_Installation_Waiting" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./mykey-pair")
    host        = aws_eip.Warip.public_ip
  }

  //copy the installation script
  provisioner "file" {
    source = "installWar.sh"
	  destination = "/tmp/installWar.sh"
  }
 
  //run the installer
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installWar.sh",
	    "sudo /tmp/installWar.sh"
	  ]
  }
}