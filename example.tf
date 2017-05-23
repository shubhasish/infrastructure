
provider "aws" {
  access_key = "${var.accessKey}"
  secret_key = "${var.secretKey}"
  region     = "${var.region}"
}

resource "aws_instance" "example" {
connection {
type = "ssh"
user = "ubuntu"
private_key = "${file(var.keyPath)}"

}

security_groups = ["launch-wizard-1"]
ami           = "ami-c2ee9dad"
  instance_type = "t2.micro"
key_name = "linux3"
provisioner "remote-exec" {
inline = ["sudo mkdir -p /etc/nomad.d/configFiles","sudo mkdir -p /etc/consul.d/configFiles",]
}
provisioner "file" {
source = "/etc/consul.d/consul_configs"
destination = "/tmp" 
}
provisioner "remote-exec" {
inline = ["sudo cp -r /tmp/consul_configs/* /etc/consul.d/",]

}

provisioner "remote-exec" {
scripts =["/tmp/startupScripts/consul.sh","/tmp/startupScripts/nomad.sh","/tmp/startupScripts/docker.sh"]
}}
