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
  region  = var.region  // our account allows for us-east-1 or us-east-2 farms
}

// resource keyword defines infrastructure objects

// Generates a secure private key and encodes it as Privacy Enhanced Mail (PEM. )
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// Defines the Virtual Private Cloud (VPC)
resource "aws_vpc" "test-env" {
  cidr_block = var.VPC_cidr // Classless Inter-Domain Routing
  enable_dns_hostnames = true
  enable_dns_support = true
}

// Create Public Subnet for Amazon Elastic Compute Cloud (EC2)
resource "aws_subnet" "test-subnet-public-1" {
  vpc_id                  = "${aws_vpc.test-env.id}"
  cidr_block              = var.subnet1_cidr
  map_public_ip_on_launch = "true" //it makes this a public subnet so others can access it
  availability_zone       = var.AZ1

}

// Create Private subnet for Relational Database (RDS)
resource "aws_subnet" "test-subnet-private-1" {
  vpc_id                  = "${aws_vpc.test-env.id}"
  cidr_block              = var.subnet2_cidr
  map_public_ip_on_launch = "false" //it makes private subnet
  availability_zone       = var.AZ2

}

// Create second Private subnet for RDS
resource "aws_subnet" "test-subnet-private-2" {
  vpc_id                  = "${aws_vpc.test-env.id}"
  cidr_block              = var.subnet3_cidr
  map_public_ip_on_launch = "false" //it makes private subnet
  availability_zone       = var.AZ3

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

// A security group that allows private network traffic only
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
    description = "MYSQL"
    from_port   = 3306
    to_port     = 3306
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


// Security group for RDS
resource "aws_security_group" "RDS_allow_rule" {
  vpc_id = "${aws_vpc.test-env.id}"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ec2_allow_rule.id}"]
  }
  // Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow ec2"
  }

}

// Create RDS Subnet group
resource "aws_db_subnet_group" "RDS_subnet_grp" {
  subnet_ids = ["${aws_subnet.test-subnet-private-1.id}", "${aws_subnet.test-subnet-private-2.id}"]
}

// Create a relations database (RDS) instance
resource "aws_db_instance" "wordpressdb" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.instance_class
  db_subnet_group_name   = aws_db_subnet_group.RDS_subnet_grp.id
  vpc_security_group_ids = ["${aws_security_group.RDS_allow_rule.id}"]
  name                   = var.database_name
  username               = var.database_user
  password               = var.database_password
  skip_final_snapshot    = true
}

// change USERDATA variable value after grabbing RDS endpoint info
data "template_file" "user_data" {
  template = file("./user_data.tpl")
  vars = {
    db_username      = var.database_user
    db_user_password = var.database_password
    db_name          = var.database_name
    db_RDS           = aws_db_instance.wordpressdb.endpoint
  }
}

// Define the Centos amazon image
data "aws_ami" "linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }


  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

// Create EC2 ( only after RDS is provisioned)
resource "aws_instance" "wordpressec2" {
  ami             = data.aws_ami.linux2.id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.test-subnet-public-1.id
  security_groups = ["${aws_security_group.ec2_allow_rule.id}"]
  user_data       = data.template_file.user_data.rendered
  key_name        = aws_key_pair.mykey-pair.id
  tags = {
    Name = "Wordpress.web"
  }

  // this will stop creating EC2 before RDS is provisioned
  depends_on = [aws_db_instance.wordpressdb]
}

// Sends your public key to the instance. The key pair is used to control login access to EC2 instances.
resource "aws_key_pair" "mykey-pair" {
  key_name   = "mykey-pair"
  public_key = file(var.PUBLIC_KEY_PATH)
}

// creating Elastic IP for EC2
resource "aws_eip" "eip" {
  instance = aws_instance.wordpressec2.id

}

// output keyword extracts the value of an output variable from the state file.

// Get the IP address
output "IP" {
  value = aws_eip.eip.public_ip
}

// Get the DB value
output "RDS-Endpoint" {
  value = aws_db_instance.wordpressdb.endpoint
}

// Get the address to access
output "INFO" {
  value = "AWS Resources and Wordpress has been provisioned. Go to http://${aws_eip.eip.public_ip}"
}

// configure provisioners that are not directly associated with a single existing resource i.e. wordpress
resource "null_resource" "Wordpress_Installation_Waiting" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.PRIV_KEY_PATH)
    host        = aws_eip.eip.public_ip
  }

  // monitor the installation
  provisioner "remote-exec" {
    inline = ["sudo tail -f -n0 /var/log/cloud-init-output.log| grep -q 'WordPress Installed'"]

  }
}