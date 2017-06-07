
provider "aws" {
  access_key = "${var.accessKey}"
  secret_key = "${var.secretKey}"
  region     = "${var.region}"
}

module "security" {
source = "./modules/security"
key_name = "${var.key_name}"
conn_user = "${var.conn_user}"
keyPath = "${var.keyPath}"

}


module "consul_server1" {
source = "./modules/consul_servers"

ami = "${var.ami}"
instance_type = "${var.instance_type}"
key_name = "${var.key_name}"
conn_user = "${var.conn_user}"
keyPath = "${var.keyPath}"
bastionHost ="${module.security.eip}"
subnet_id = "${module.security.private}"

security_group = "${module.security.security}"


}

module "consul_server2" {
source = "./modules/consul_servers"

ami = "${var.ami}"
instance_type = "${var.instance_type}"
key_name = "${var.key_name}"
conn_user = "${var.conn_user}"
keyPath = "${var.keyPath}"
bastionHost ="${module.security.eip}"


subnet_id = "${module.security.private}"

security_group = "${module.security.security}"
}


module "consul_server3" {

source = "./modules/consul_servers"
bastionHost ="${module.security.eip}"

ami = "${var.ami}"
instance_type = "${var.instance_type}"
key_name = "${var.key_name}"
conn_user = "${var.conn_user}"
keyPath = "${var.keyPath}"

subnet_id = "${module.security.private}"

security_group = "${module.security.security}"

}
module "consul_client" {
source = "./modules/consul_client"

ami = "${var.ami}"
instance_type = "${var.instance_type}"
key_name = "${var.key_name}"
conn_user = "${var.conn_user}"
keyPath = "${var.keyPath}"
homeDir = "${var.homeDir}"

subnet_id = "${module.security.public}"

}
