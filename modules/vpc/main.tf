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
