terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

# Change region if needed
provider "aws" {
  region = "us-east-1"  # Make sure this matches your AMI region
}

# Security group allowing SSH
resource "aws_security_group" "ssh_access" {
  name        = "ssh_access_sg"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the world; change to your IP for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "app_server" {
  ami           = "ami-03aa99ddf5498ceb9"
  instance_type = "t3.micro"
  key_name      = "your-ssh-key-name"   # Replace with your AWS key pair

  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  tags = {
    Name = "Terraform_Demo"
  }
}

# Output the public IP
output "app_server_public_ip" {
  value = aws_instance.app_server.public_ip
}
