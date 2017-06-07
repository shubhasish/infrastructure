variable "keyPath"{
default = "/home/talentica/Downloads/drive-download-20170513T171142Z-001/linux3.pem"}

variable "accessKey" {
default = "AKIAJ6KSHXVOAOO4AH7Q"}

variable "secretKey" {
default = "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" }

variable "region" {
default = "ap-south-1" }

variable "count" {
default = "3" }

variable "ami" {
default = "ami-c2ee9dad" }

variable "instance_type" {
default = "t2.micro" }

variable "key_name" {
default = "linux3" }

variable "conn_user" {
default = "ubuntu"}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "ap-south-1"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        ap-south-1 = "ami-83c2b1ec" # ubuntu 16.04 LTS
    }
}


variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.1.0/24"
}

