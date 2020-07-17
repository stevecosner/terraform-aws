# Create ubuntu EC2 with user steve with ssh key.

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-east-2"
}

resource "aws_instance" "webt1" {
  ami           = "ami-0b32ec75f2cd21d30"
  instance_type = "t2.micro"
  key_name = "id_rsa_msa"
  #subnet_id = "${var.aws_subnet}"
  #vpc_security_group_ids = ["${var.aws_security_group}"]

connection {
        user = "ubuntu"
        type = "ssh"
        private_key = "${file("id_rsa_msa")}"
        timeout = "2m"
        host = "${self.public_ip}"
}
    provisioner "remote-exec" {
        inline = [
          "sleep 25",
          "sudo useradd -p $(openssl passwd -1 TheBigNest123) steve",
          "sudo mkdir /home/steve",
          "sudo chmod 700 /home/steve",
          "sudo chown steve:steve /home/steve",
          "sudo usermod -s /bin/bash steve",
          "sudo cp .profile /home/steve",
          "sudo cp /etc/skel/.bashrc /home/steve",
          "sudo chown steve:steve /home/steve/.profile",
          "sudo chown steve:steve /home/steve/.bashrc",
          "sudo mkdir /home/steve/.ssh",
          "sudo chown steve:steve /home/steve/.ssh",
          "sudo usermod -aG sudo steve",
          #"sudo echo 'steve ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
          ]
}


    provisioner "file" {
      source      = "id_rsa_msa.pub"
      destination = "/home/ubuntu/authorized_keys"
}

    provisioner "remote-exec" {
        inline = [
          "sleep 25",


          "sudo cp /home/ubuntu/authorized_keys /home/steve/.ssh/",
          "sudo chown steve:steve /home/steve/.ssh/authorized_keys",
          "sudo chmod 600 /home/steve/.ssh/authorized_keys",
          "sudo chmod 700 /home/steve/.ssh"
          ]
}

}

