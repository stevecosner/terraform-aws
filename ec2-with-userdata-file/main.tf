# README

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-east-2"
}

resource "aws_instance" "webt1" {
  ami           = "ami-021b7b04f1ac696c2"
  user_data          = "${file("web.conf")}"
  instance_type = "t2.micro"
  key_name = "id_rsa_msa"
}

output "public_instance_ip" {
  value = ["${aws_instance.webt1.public_ip}"]
}
