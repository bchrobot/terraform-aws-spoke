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
  bucket = "${var.s3_bucket_name}"
  acl    = "private"

  tags {
    Name = "Spoke Bucket"
  }
}


module "vpc" {
  source = "./modules/vpc"

  aws_region = "${var.aws_region}"
}


# Postgres RDS instance
module "postgres" {
  source = "./modules/rds-postgres"

  vpc_id        = "${module.vpc.vpc_id}"
  subnet_ids    = ["${module.vpc.aws_public_subnet_ids}"]
  rds_password  = "${var.rds_password}"
}


# Upload resources
# Source: https://www.terraform.io/docs/providers/aws/r/s3_bucket_object.html

# Upload Client Resources
resource "aws_s3_bucket_object" "client_payload" {
  acl    = "public-read"
  bucket = "${var.s3_bucket_name}"
  key    = "static/bundle.${var.client_bundle_hash}.js"
  source = "${var.client_bundle_location}"
  etag   = "${md5(file("${var.client_bundle_location}"))}"
  depends_on = ["aws_s3_bucket.spoke_bucket"]
}

# Upload Lambda Function
resource "aws_s3_bucket_object" "server_payload" {
  bucket = "${var.s3_bucket_name}"
  key    = "deploy/server.zip"
  source = "${var.server_bundle_location}"
  etag   = "${md5(file("${var.server_bundle_location}"))}"
  depends_on = ["aws_s3_bucket.spoke_bucket"]
}

module "lambda" {
  source = "./modules/lambda-function"

  vpc_id      = "${module.vpc.vpc_id}"
  subnet_ids  = ["${module.vpc.aws_private_subnet_ids}"]
  aws_region  = "${var.aws_region}"
  s3_bucket_name   = "${var.s3_bucket_name}"
  s3_key      = "deploy/server.zip"
  source_code_hash  = "${base64sha256(file("${var.server_bundle_location}"))}"

  db_host     = "${module.postgres.address}"
  db_port     = "${module.postgres.port}"
  db_name     = "${module.postgres.name}"
  db_user     = "${module.postgres.username}"
  db_password = "${var.rds_password}"

  spoke_domain = "${var.spoke_domain}"
  spoke_suppress_seed = "${var.spoke_suppress_seed}"
  spoke_suppress_self_invite = "${var.spoke_suppress_self_invite}"
  spoke_session_secret = "${var.spoke_session_secret}"
  spoke_timezone = "${var.spoke_timezone}"
  spoke_lambda_debug = "${var.spoke_lambda_debug}"

  spoke_default_service = "${var.spoke_default_service}"
  spoke_twilio_account_sid = "${var.spoke_twilio_account_sid}"
  spoke_twilio_auth_token = "${var.spoke_twilio_auth_token}"
  spoke_twilio_message_service_sid = "${var.spoke_twilio_message_service_sid}"
  spoke_nexmo_api_key = "${var.spoke_nexmo_api_key}"
  spoke_nexmo_api_secret = "${var.spoke_nexmo_api_secret}"

  spoke_auth0_domain = "${var.spoke_auth0_domain}"
  spoke_auth0_client_id = "${var.spoke_auth0_client_id}"
  spoke_auth0_client_secret = "${var.spoke_auth0_client_secret}"

  spoke_email_from = "${var.spoke_email_from}"
  spoke_email_host = "${var.spoke_email_host}"
  spoke_email_host_port = "${var.spoke_email_host_port}"
  spoke_email_host_user = "${var.spoke_email_host_user}"
  spoke_email_host_password = "${var.spoke_email_host_password}"
  spoke_mailgun_api_key = "${var.spoke_mailgun_api_key}"
  spoke_mailgun_domain = "${var.spoke_mailgun_domain}"
  spoke_mailgun_public_key = "${var.spoke_mailgun_public_key}"
  spoke_mailgun_smtp_login = "${var.spoke_mailgun_smtp_login}"
  spoke_mailgun_smtp_password = "${var.spoke_mailgun_smtp_password}"
  spoke_mailgun_smtp_port = "${var.spoke_mailgun_smtp_port}"
  spoke_mailgun_smtp_server = "${var.spoke_mailgun_smtp_server}"

  spoke_action_handlers = "${var.spoke_action_handlers}"
  spoke_ak_baseurl = "${var.spoke_ak_baseurl}"
  spoke_ak_secret = "${var.spoke_ak_secret}"

  spoke_rollbar_client_token = "${var.spoke_rollbar_client_token}"
  spoke_rollbar_endpoint = "${var.spoke_rollbar_endpoint}"

  fake_depends_on  = ["${aws_s3_bucket_object.server_payload.id}"]
}

module "api_gateway" {
  source = "./modules/api-gateway"

  invoke_arn = "${module.lambda.invoke_arn}"
  function_arn = "${module.lambda.function_arn}"
}
