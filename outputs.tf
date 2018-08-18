# Spoke Deployment Output
# 
# Print information about the resources created. These values will be needed
# in the Claudia.js deploy command.
# 
# Source: https://www.terraform.io/intro/getting-started/outputs.html

output "VPC ID" {
  value = "${aws_vpc.spoke_vpc.id}"
}

output "Public Subnets" {
  value = "${aws_subnet.public_a.id}, ${aws_subnet.public_b.id}"
}

output "Private Subnets" {
  value = "${aws_subnet.private_a.id}, ${aws_subnet.private_b.id}"
}

output "RDS Security Group" {
  value = "${aws_security_group.postgres.id}"
}

output "Lambda Security Group" {
  value = "${aws_security_group.lambda.id}"
}

output "S3 Bucket Name" {
  value = "${var.spoke_domain}"
}
