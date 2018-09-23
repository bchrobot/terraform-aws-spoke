# -----------------------
# AWS Variables
# -----------------------

variable "vpc_id" {
  type        = "string"
  description = "The ID of the VPC to create the Postgres instance within. Example: aws_vpc.spoke_vpc.id"
}

variable "subnet_ids" {
  type        = "list"
  description = "A list of subnet IDs to add the Postgres instance to. Example: ['${aws_subnet.public_a.id}', '${aws_subnet.public_b.id}']"
}

variable "publicly_accessible" {
  type        = "string"
  description = "Whether the RDS instance shall be publicly accessible."
  default     = "1"
}


# -----------------------
# Database Variables
# -----------------------

variable "rds_class" {
  type        = "string"
  description = "The RDS class for the instance."
  default     = "db.t2.medium"
}

variable "rds_identifier" {
  type        = "string"
  description = "The name of the RDS instance."
  default     = "spokedb"
}

variable "rds_size" {
  description = "The storage size in gibibytes for the Postgres RDS instance."
  default     = 30
}

variable "rds_dbname" {
  type        = "string"
  description = "The DB name for the Postgres instance."
  default     = "spoke_prod"
}

variable "rds_port" {
  type        = "string"
  description = "The port the Postgres instance will listen on."
  default     = "5432"
}

variable "rds_username" {
  type        = "string"
  description = "The username for the Postgres instance."
  default     = "spoke"
}

variable "rds_password" {
  type        = "string"
  description = "The password for the Postgres instance user."
}
