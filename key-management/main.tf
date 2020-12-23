provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-east-2"
}


### Use this resource if copying an ssh key from your PC to your 
### AWS account.
##resource "aws_key_pair" "deployer" {
##  key_name   = "deployer-key"
##  public_key = file("~/.ssh/id_rsa.pub")
##}


### Use resources below to create a new SSH key to be copied to your account.

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


## Example for new EC2

#resource "aws_instance" "webt1" {
#  ami           = "ami-0b32ec75f2cd21d30"
#  instance_type = "t2.micro"
#  key_name = aws_key_pair.ssh.key_name
#}
