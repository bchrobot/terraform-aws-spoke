# Create security group for Postgres RDS
# Source: https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "postgres" {
  name        = "postgres"
  description = "Allow all inbound Postgres traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    self        = true
    description = "Postgres access"
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


# Create security group rule
# Source: https://www.terraform.io/docs/providers/aws/r/security_group_rule.html
resource "aws_security_group_rule" "allow_all_postgres" {
  # Only create rule if publicly accessible
  count       = "${var.publicly_accessible}"

  type        = "ingress"
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Postgres traffic from anywhere"

  security_group_id = "${aws_security_group.postgres.id}"
}


# Create RDS Subnet Group
# Source: https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html
resource "aws_db_subnet_group" "postgres" {
  name       = "postgres"
  subnet_ids = ["${var.subnet_ids}"]

  tags {
    Name = "Spoke Postgres"
  }
}



# Create RDS Postgres instance
# Source: https://www.terraform.io/docs/providers/aws/r/db_instance.html
resource "aws_db_instance" "spoke" {
  identifier             = "${var.rds_identifier}"
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
  skip_final_snapshot    = true
  db_subnet_group_name   = "${aws_db_subnet_group.postgres.name}"
  vpc_security_group_ids = ["${aws_security_group.postgres.id}"]
}
