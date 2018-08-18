# Spoke Variables
# 
# Customize these for your Spoke deployment.
# 
# Source: https://www.terraform.io/intro/getting-started/variables.html


variable "aws_access_key" {
  description = "AWS Access Key."
}

variable "aws_secret_key" {
  description = "AWS Secret Key."
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "spoke_domain" {
  description = "The domain that Spoke will be running on."
  default     = "spoke.example.com"
}

variable "rds_size" {
  description = "The storage size in gibibytes for the Postgres RDS instance."
  default     = 30
}

variable "rds_class" {
  description = "The RDS class for the instance."
  default     = "db.t2.medium"
}

variable "rds_dbname" {
  description = "The DB name for the Postgres instance."
  default     = "spoke_prod"
}

variable "rds_port" {
  description = "The port the Postgres instance will listen on."
  default     = "5432"
}

variable "rds_username" {
  description = "The username for the Postgres instance."
  default     = "spoke"
}

variable "rds_password" {
  description = "The password for the Postgres instance user."
}
