variable "ami"{}
variable "instance_type"{}
variable "key_name"{}
variable "subnet_id"{}
variable "security_group"{}
variable "conn_user" {}
variable "keyPath"{}
variable "bastionHost" {}


resource "aws_instance" "example" {

connection {
type = "ssh"
user = "${var.conn_user}"
private_key = "${file(var.keyPath)}"


bastion_host= "${var.bastionHost}"
bastion_port= "22"
bastion_private_key= "${file(var.keyPath)}"
bastion_user= "ec2-user"
}

availability_zone = "ap-south-1a"
subnet_id ="${var.subnet_id}"
security_groups = ["${var.security_group}"]




ami           = "${var.ami}"

instance_type = "${var.instance_type}"

key_name = "${var.key_name}"


provisioner "remote-exec" {
inline = ["sudo mkdir -p /etc/nomad.d/configFiles","sudo mkdir -p /etc/consul.d/configFiles",]
}

provisioner "file" {
source = "~/infrastructure/configfiles/consul/server"
destination = "/tmp" 
}

provisioner "remote-exec" {
inline = ["sudo cp -r /tmp/server/* /etc/consul.d/",]

}

provisioner "remote-exec" {
scripts =["~/infrastructure/startupScripts/consul.sh","/tmp/startupScripts/nomad.sh","/tmp/startupScripts/docker.sh"]
}
}
