resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags {
        Name = "terraform-aws-vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = "${aws_vpc.default.id}"
    depends_on = ["aws_vpc.default"]
    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true

    tags {
        Name = "Public Subnet"
    }
}

/*
  Private Subnet
*/
resource "aws_subnet" "private_subnet" {
    vpc_id = "${aws_vpc.default.id}"
    depends_on = ["aws_vpc.default"]
    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "ap-south-1a"

    tags {
        Name = "Private Subnet"
  
}}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
    depends_on = ["aws_vpc.default"]
}


resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.default.id}"
   # depends_on = ["aws_internet_gateway.default"]
    route {
        cidr_block = "0.0.0.0/0"
       #instance_id = "${aws_instance.nat.id}"       
    gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "Public Route Table"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.public_subnet.id}"
    route_table_id = "${aws_route_table.public.id}"
}


resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.default.id}"

   route{ 
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
   }

    tags {
        Name = "Private Route Table"
    }
}

resource "aws_instance" "nat" {

    connection {
         type = "ssh"
         user = "${var.conn_user}"
         private_key = "${file(var.keyPath)}"
               }

    ami = "ami-85c1b2ea" # this is a special ami preconfigured to do NAT
    availability_zone = "ap-south-1a"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    vpc_security_group_ids = ["${aws_security_group.nat.id}"]
    subnet_id = "${aws_subnet.public_subnet.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "VPC NAT"
    }
}

resource "aws_route_table_association" "private" {
    subnet_id = "${aws_subnet.private_subnet.id}"
    route_table_id = "${aws_route_table.private.id}"
}


resource "aws_security_group" "nat" {
    name = "vpc_nat"
    description = "Allow traffic to pass from the private subnet to the internet"
    
    ingress {
        from_port = 0
        to_port = 65355
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }
    /*ingress {
        from_port = all
        to_port = all
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }*/
    ingress {
        from_port = 0
        to_port = 65355
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = -1
        to_port = -1
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
/*
    egress {
        from_port = all
        to_port = all
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
*/
    egress {
        from_port = -1
        to_port = -1
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }
    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "NATSG"
    }
}



resource "aws_eip" "nat" {
    instance = "${aws_instance.nat.id}"
    vpc = true
}


/*resource "aws_nat_gateway" "nat" {
    depends_on = ["aws_eip.nat"]
    allocation_id = "${aws_eip.nat.id}"
    subnet_id = "${aws_subnet.public_subnet.id}"
}*/

/*
resource "null_resource" "depends_on" {
depends_on = ["aws_subnet.public_subnet","aws_subnet.private_subnet","aws_security_group.nat"]}

output "depends" {
value = "${null_resource.depends_on.id}"
}*/
