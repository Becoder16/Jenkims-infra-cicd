terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "s3monitorobject"
    key    = "state.tf"
    region = "us-east-1"
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "Server-1" {
     ami = "${var.ami}"
     instance_type = "${var.instance_type}"
     tags = {
         Name = "Server-1"
         Env = "Test"
     }
lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For SSH from anywhere - restrict if needed
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2_Security_Group"
  }
}

data "aws_vpc" "default" {
  default = true
}





