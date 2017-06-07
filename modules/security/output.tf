output "public" {
value = "${aws_subnet.public_subnet.id}"
}

output "private" {
value = "${aws_subnet.private_subnet.id}"
}

output "security" {
value = "${aws_security_group.nat.id}"
}


output "eip" {
value = "${aws_eip.nat.public_ip}"
}

