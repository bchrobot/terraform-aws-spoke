# Spoke on AWS
# 
# This will automate creation of resources for running Spoke on AWS. This only
# takes care of the resource creation listed in the first section of the AWS
# Deploy guide (docs/DEPLOYING_AWS_LAMBDA.md). It will _not_ actually deploy
# the code.
# 
# Author: @bchrobot <benjamin.blair.chrobot@gmail.com>
# Version 0.1.0



# Configure AWS Provider
# Source: https://www.terraform.io/docs/providers/aws/index.html
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}



# Lookup the certificate (must be created _before_ running `terraform apply`)
# Source: https://www.terraform.io/docs/providers/aws/d/acm_certificate.html
# data "aws_acm_certificate" "spoke_certificate" {
#   domain   = "${var.spoke_domain}"
#   statuses = ["ISSUED"]
# }
# Could also create cert (and then wait for validation):
# Source: https://www.terraform.io/docs/providers/aws/r/acm_certificate.html
resource "aws_acm_certificate" "spoke_cert" {
  domain_name       = "${var.spoke_domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}



# Create the bucket
# Source: https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
resource "aws_s3_bucket" "spoke_bucket" {
  bucket = "${var.spoke_domain}"
  acl    = "private"

  tags {
    Name = "Spoke Bucket"
  }
}



# Create VPC
# Source: https://www.terraform.io/docs/providers/aws/r/vpc.html
resource "aws_vpc" "spoke_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support     = true
  enable_dns_hostnames   = true

  tags {
    Name = "Spoke VPC"
  }
}



# Create Internet Gateway
# Source: https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.spoke_vpc.id}"

  tags {
    Name = "Spoke IGW"
  }
}



# Create Subnets
# Source: https://www.terraform.io/docs/providers/aws/r/subnet.html

# Public A
resource "aws_subnet" "public_a" {
  vpc_id     = "${aws_vpc.spoke_vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags {
    Name = "Public A"
  }
}

# Public B
resource "aws_subnet" "public_b" {
  vpc_id     = "${aws_vpc.spoke_vpc.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"

  tags {
    Name = "Public B"
  }
}

# Private A
resource "aws_subnet" "private_a" {
  vpc_id     = "${aws_vpc.spoke_vpc.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "${var.aws_region}a"

  tags {
    Name = "Private A"
  }
}

# Private B
resource "aws_subnet" "private_b" {
  vpc_id     = "${aws_vpc.spoke_vpc.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "${var.aws_region}b"

  tags {
    Name = "Private B"
  }
}



# Create EIP for NAT
# Source: https://www.terraform.io/docs/providers/aws/r/eip.html
resource "aws_eip" "lambda_nat" {
  vpc = true

  depends_on                = ["aws_internet_gateway.gw"]
}



# Create NAT Gateway
# Source: https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.lambda_nat.id}"
  subnet_id     = "${aws_subnet.public_a.id}"

  tags {
    Name = "Lambda NAT"
  }

  # Source: https://www.terraform.io/docs/providers/aws/r/nat_gateway.html#argument-reference
  depends_on = ["aws_internet_gateway.gw"]
}



# Create Route Tables
# Source: https://www.terraform.io/docs/providers/aws/r/route_table.html

# Public
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.spoke_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Public Route Table"
  }
}

# Private
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.spoke_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.gw.id}"
  }

  tags {
    Name = "Private Route Table"
  }
}



# Add Subnets to Route Tables
# Source: https://www.terraform.io/docs/providers/aws/r/route_table_association.html

# Public Route Table
resource "aws_route_table_association" "public_a" {
  subnet_id      = "${aws_subnet.public_a.id}"
  route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "public_b" {
  subnet_id      = "${aws_subnet.public_b.id}"
  route_table_id = "${aws_route_table.public.id}"
}

# Private Route Table
resource "aws_route_table_association" "private_a" {
  subnet_id      = "${aws_subnet.private_a.id}"
  route_table_id = "${aws_route_table.private.id}"
}
resource "aws_route_table_association" "private_b" {
  subnet_id      = "${aws_subnet.private_b.id}"
  route_table_id = "${aws_route_table.private.id}"
}



# Create Security Groups
# Source: https://www.terraform.io/docs/providers/aws/r/security_group.html

# Lambda
resource "aws_security_group" "lambda" {
  name        = "lambda"
  description = "Allow all inbound web traffic"
  vpc_id      = "${aws_vpc.spoke_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = true
    description = "Web traffic"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    self        = true
    description = "Encrypted web traffic"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "Spoke Lambda"
  }
}

# Postgres RDS
resource "aws_security_group" "postgres" {
  name        = "postgres"
  description = "Allow all inbound Postgres traffic"
  vpc_id      = "${aws_vpc.spoke_vpc.id}"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    self        = true
    description = "Postgres traffic from anywhere"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "Spoke Postgres"
  }
}



# Create RDS Subnet Group
# Source: https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html
resource "aws_db_subnet_group" "postgres" {
  name       = "postgres"
  subnet_ids = ["${aws_subnet.public_a.id}", "${aws_subnet.public_b.id}"]

  tags {
    Name = "Spoke Postgres"
  }
}



# Create RDS Postgres instance
# Source: https://www.terraform.io/docs/providers/aws/r/db_instance.html
resource "aws_db_instance" "default" {
  allocated_storage      = "${var.rds_size}"
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "10.4"
  instance_class         = "${var.rds_class}"
  name                   = "${var.rds_dbname}"
  port                   = "${var.rds_port}"
  username               = "${var.rds_username}"
  password               = "${var.rds_password}"
  option_group_name      = "default:postgres-10"
  parameter_group_name   = "default.postgres10"
  publicly_accessible    = true
  db_subnet_group_name   = "${aws_db_subnet_group.postgres.name}"
  vpc_security_group_ids = ["${aws_security_group.postgres.id}"]
}










# Roles
# Source: https://www.terraform.io/docs/providers/aws/r/iam_role.html
# Source: https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
# Source: https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html

# S3 Role/Policy

# resource "aws_iam_role_policy" "lambda_s3" {
#   name = "LambdaS3"
#   role = "${aws_iam_role.lambda_s3.id}"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": "s3:*",
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role" "test_role" {
#   name = "SpokeOnLambda"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }