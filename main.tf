provider "aws" {
    region = "us-east-1"
#   access_key = "xxxxxxxxx"
#   secret_key = "xxxxxxxxx"
}

resource "aws_vpc" "dev_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "dev_vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "dev_subnet"
  }
}

resource "aws_instance" "dev_ec2" {
  ami           = ami-085925f297f89ce1
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}