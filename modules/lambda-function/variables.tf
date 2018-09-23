# -----------------------
# Lambda Function Variables
# -----------------------

variable "fake_depends_on" {
  type        = "list"
  description = "https://github.com/hashicorp/terraform/issues/1178#issuecomment-105613781"
  default     = []
}

variable "aws_region" {
  type        = "string"
  description = "AWS region to launch servers. Ex. us-east-1"
}

variable "vpc_id" {
  type        = "string"
  description = "ID of the VPC the Spoke function should belong to."
}

variable "subnet_ids" {
  type        = "list"
  description = "IDs of the subnets the Lambda function should belong to."
}

variable "s3_bucket_name" {
  type        = "string"
  description = "The name of the S3 bucket where the server bundle resides."
}

variable "s3_key" {
  type        = "string"
  description = "S3 key of the server bundle."
}

variable "source_code_hash" {
  type        = "string"
  description = "Hash of server bundle. Used to determine if source code has changed and function needs updating."
}

# RDS

variable "db_host" {
  type        = "string"
  description = "The address of the Postgres instance."
}

variable "db_port" {
  type        = "string"
  description = "The port the Postgres instance will listen on."
}

variable "db_name" {
  type        = "string"
  description = "The DB name for the Postgres instance."
}

variable "db_user" {
  type        = "string"
  description = "The username for the Postgres instance."
}

variable "db_password" {
  type        = "string"
  description = "The password for the Postgres instance user."
}


# -----------------------
# Spoke Variables
# -----------------------

# Spoke

variable "spoke_domain" {
  type        = "string"
  description = "The domain that Spoke will be running on. Ex. spoke.example.com"
}

variable "spoke_suppress_seed" {
  type        = "string"
  description = "Prevent seed calls from being run automatically."
  default     = "1"
}

variable "spoke_suppress_self_invite" {
  type        = "string"
  description = "Prevent users from being able to create organizations."
  default     = "1"
}

variable "spoke_session_secret" {
  type        = "string"
  description = "Session secret."
  default     = ""
}

variable "spoke_timezone" {
  type        = "string"
  description = "Timezone that Spoke is operating in."
  default     = "America/New_York"
}

variable "spoke_lambda_debug" {
  type        = "string"
  description = "Lambda debug flag."
  default     = "0"
}


# SMS

variable "spoke_default_service" {
  type        = "string"
  description = "The SMS service to use."
  default     = "twilio"
}

## Twilio

variable "spoke_twilio_account_sid" {
  type        = "string"
  description = "Twilio Account SID."
  default     = ""
}

variable "spoke_twilio_auth_token" {
  type        = "string"
  description = "Twilio auth token."
  default     = ""
}

variable "spoke_twilio_message_service_sid" {
  type        = "string"
  description = "Twilio Message Service SID."
  default     = ""
}

## Nexmo

variable "spoke_nexmo_api_key" {
  type        = "string"
  description = "Nexmo API key."
  default     = ""
}

variable "spoke_nexmo_api_secret" {
  type        = "string"
  description = "Nexmo API secret."
  default     = ""
}


# Auth0

variable "spoke_auth0_domain" {
  type        = "string"
  description = "Auth0 domain."
  default     = "domain.auth0.com"
}

variable "spoke_auth0_client_id" {
  type        = "string"
  description = "Auth0 client ID."
  default     = ""
}

variable "spoke_auth0_client_secret" {
  type        = "string"
  description = "Auth0 client secret."
  default     = ""
}


# Email

## SMTP

variable "spoke_email_host" {
  type        = "string"
  description = "Email host."
  default     = ""
}

variable "spoke_email_host_port" {
  type        = "string"
  description = "Email host port."
  default     = ""
}

variable "spoke_email_host_user" {
  type        = "string"
  description = "Email host username."
  default     = ""
}

variable "spoke_email_host_password" {
  type        = "string"
  description = "Email host password."
  default     = ""
}

variable "spoke_email_from" {
  type        = "string"
  description = "Address to send emails from."
  default     = ""
}

## Mailgun

variable "spoke_mailgun_api_key" {
  type        = "string"
  description = "Mailgun API key."
  default     = ""
}

variable "spoke_mailgun_domain" {
  type        = "string"
  description = "Mailgun domain."
  default     = ""
}

variable "spoke_mailgun_public_key" {
  type        = "string"
  description = "Mailgun public key."
  default     = ""
}

variable "spoke_mailgun_smtp_login" {
  type        = "string"
  description = "Mailgun SMTP login username."
  default     = ""
}

variable "spoke_mailgun_smtp_password" {
  type        = "string"
  description = "Mailgun SMTP login password."
  default     = ""
}

variable "spoke_mailgun_smtp_port" {
  type        = "string"
  description = "Mailgun SMTP port."
  default     = "587"
}

variable "spoke_mailgun_smtp_server" {
  type        = "string"
  description = "Mailgun SMTP host."
  default     = "smtp.mailgun.org"
}


# Action Handlers

variable "spoke_action_handlers" {
  type        = "string"
  description = "Enabled Action Handlers."
  default     = ""
}

## ActionKit

variable "spoke_ak_baseurl" {
  type        = "string"
  description = "ActionKit base URL."
  default     = ""
}

variable "spoke_ak_secret" {
  type        = "string"
  description = "ActionKit secret."
  default     = ""
}


# Rollbar

variable "spoke_rollbar_client_token" {
  type        = "string"
  description = "Rollbar client token."
  default     = ""
}

variable "spoke_rollbar_endpoint" {
  type        = "string"
  description = "Rollbar endpoint."
  default     = "https://api.rollbar.com/api/1/item/"
}
