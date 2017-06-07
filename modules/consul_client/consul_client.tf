variable "ami"{}
variable "instance_type"{}
variable "key_name"{}
variable "subnet_id"{}
variable "conn_user" {}
variable "keyPath"{}
variable "homeDir"{}

resource "aws_instance" "client" {

connection {
type = "ssh"
user = "${var.conn_user}"
private_key = "${file(var.keyPath)}"

}
availability_zone = "ap-south-1a"
subnet_id ="${var.subnet_id}"
security_groups = ["launch-wizard-2"]




ami           = "${var.ami}"

instance_type = "${var.instance_type}"

key_name = "${var.key_name}"


provisioner "remote-exec" {
scripts = ["${var.homeDir}/startupScripts/mkdir.sh"]
}

provisioner "file" {
source = "${var.homeDir}/configfiles/consul/client"
destination = "/tmp" 
}

provisioner "file" {
source = "${var.homeDir}/dockerfiles"
destination = "/tmp"
}

provisioner "file" {
source = "${var.homeDir}/configfiles/tick"
destination = "/tmp"
}

provisioner "remote-exec" {
inline = ["sudo cp -r /tmp/client/* /etc/consul.d/",]

}

provisioner "remote-exec" {
inline = ["sudo cp -r /tmp/tick/telegraf.conf /etc/telegraf/",]

}
provisioner "remote-exec" {
inline = ["sudo cp -r /tmp/tick/kapacitor.conf /etc/kapacitor/",]

}
provisioner "remote-exec" {
inline = ["sudo cp -r /tmp/tick/influxdb.conf /etc/influxdb/",]

}
provisioner "remote-exec" {
inline = ["sudo cp -r /tmp/dockerfiles/* /etc/docker.d/",]

}

provisioner "remote-exec" {
scripts =["${var.homeDir}/startupScripts/consul.sh","${var.homeDir}/startupScripts/nomad.sh","${var.homeDir}/startupScripts/docker.sh"]
}
}

