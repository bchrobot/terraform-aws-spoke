output "vpc_id" {
  value = "${aws_vpc.spoke_vpc.id}"
}

output "aws_public_subnet_ids" {
  value = ["${aws_subnet.public_a.id}", "${aws_subnet.public_b.id}"]
}

output "aws_private_subnet_ids" {
  value = ["${aws_subnet.private_a.id}", "${aws_subnet.private_b.id}"]
}
