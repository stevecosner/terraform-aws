

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-east-2"
}

resource "aws_instance" "aws-2-1" {
  ami           = "ami-07c8bc5c1ce9598c3"
  instance_type = "t2.micro"
  key_name = "id_rsa_msa"


connection {
        user = "ec2-user"
        type = "ssh"
        private_key = "${file("id_rsa_msa")}"
        timeout = "2m"
        host = "${self.public_ip}"

}
    provisioner "remote-exec" {
        inline = [
          "sleep 25",
          "sudo yum update -y",
          #"sudo yum-config-manager --enable rhel-server-extras",
          "sudo yum install docker -y"
          
          ]
}

}

output "public_instance_ip" {
  value = ["${aws_instance.aws-l-1.public_ip}"]

}