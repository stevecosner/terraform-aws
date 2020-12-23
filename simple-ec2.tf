# ubuntu18 ami-021b7b04f1ac696c2
# centos7 ami-01e36b7901e884a10

provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-east-2"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name = "PrivateMachine"
  public_key = tls_private_key.ssh.public_key_openssh
}

output "ssh_private_key_pem" {
  value = tls_private_key.ssh.private_key_pem
}

output "ssh_public_key_pem" {
  value = tls_private_key.ssh.public_key_pem
}

resource "aws_instance" "webt1" {
  ami           = "ami-0b32ec75f2cd21d30"
  instance_type = "t2.micro"
  key_name = aws_key_pair.ssh.key_name
}
