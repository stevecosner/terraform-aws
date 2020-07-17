# Create ubuntu EC2 with ssh key, docker, docker-compose and run nginx docker container.


provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-east-2"
}

resource "aws_instance" "dock1" {
  ami           = "ami-021b7b04f1ac696c2"
  instance_type = "t2.micro"
  key_name = "id_rsa_msa"
  #subnet_id = "${var.aws_subnet}"
  #vpc_security_group_ids = ["${var.aws_security_group}"]

connection {
        user = "ubuntu"
        type = "ssh"
        private_key = "${file("id_rsa_msa")}"
        host = "${self.public_ip}"

}
    provisioner "remote-exec" {
        inline = [
          "sleep 25",
          "sudo apt-get update",
          "sudo apt-get -y install docker-engine",
          "sudo apt-get -y install docker-compose",
          "sudo docker run -itd -p 80:80 nginx"
    

        ]
   }



}

output "public_instance_ip" {
  value = ["${aws_instance.dock1.public_ip}"]
}
