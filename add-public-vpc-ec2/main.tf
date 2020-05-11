

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-east-2"
}

resource "aws_vpc"  "terra12" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

}

resource "aws_subnet" "terra12" {
  vpc_id     = "${aws_vpc.terra12.id}"
  map_public_ip_on_launch = "true"
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "terra12" {
  vpc_id = "${aws_vpc.terra12.id}"
 
}

resource "aws_route_table" "terra12" {
  vpc_id = "${aws_vpc.terra12.id}"


  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.terra12.id}"
  }
}

resource "aws_route_table_association" "terra12" {
  subnet_id      = "${aws_subnet.terra12.id}"
  route_table_id = "${aws_route_table.terra12.id}"
}

resource "aws_security_group" "terra12" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "${aws_vpc.terra12.id}"

# SSH access from the VPC
  ingress {
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

 
}








# Creates Ubuntu 18.04 EC2 in US-east-2

resource "aws_instance" "terra12" {
  ami           = "ami-021b7b04f1ac696c2"
  instance_type = "t2.micro"
  key_name = "id_rsa_msa"
  subnet_id = "${aws_subnet.terra12.id}"
  vpc_security_group_ids = ["${aws_security_group.terra12.id}"]

}








