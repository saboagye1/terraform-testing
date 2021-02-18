#1. vpc
resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"

    tags = {
    Name = "dev_vpc"
  }
}

#2. Internet Gateway - (public IP) to send traffic to the internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id

      tags = {
    Name = "dev_igw"
  }
  }

#3. Route Table
  resource "aws_route_table" "rt" {
  vpc_id = aaws_vpc.dev_vpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "main"
  }
}


#4. aws_subnet
resource "aws_subnet" "dev_subnet" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Main"
  }
}

#5. Subnet Association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.dev_subnet.id
  route_table_id = aws_route_table.rt.id
}

#6. Security Group - what kind of traffic is allowed

resource "aws_security_group" "allow_web" {
  name        = "allow_web-traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [0.0.0.0./0]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

#7. Network interface with an ip in the subnet
resource "aws_network_interface" "dev_ni" {
  subnet_id       = aws_subnet.dev_subnet.id
  private_ips     = ["10.0.0.50"]
  security_groups = [aws_security_group.allow_web.id]

}

#8. Elastic IP to the Network interface
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.dev_ni.id
  associate_with_private_ip = "10.0.0.10"
}

