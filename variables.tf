# Spoke Variables
# 
# Customize these for your Spoke deployment.
# 
# Source: https://www.terraform.io/intro/getting-started/variables.html


########################
# AWS Deploy Variables #
########################

variable "aws_access_key" {
  description = "AWS Access Key."
}

variable "aws_secret_key" {
  description = "AWS Secret Key."
}

variable "aws_region" {
  description = "AWS region to launch servers. Ex. us-east-1"
}

variable "s3_bucket_name" {
  description = "Create a globally unique S3 bucket. Usually the same as the domain: spoke.example.com"
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

variable "bundle_hash" {
  description = "Hash of client bundle.js"
}


###################
# Spoke Variables #
###################

# Spoke

variable "spoke_domain" {
  description = "The domain that Spoke will be running on. Ex. spoke.example.com"
}

variable "spoke_suppress_seed" {
  description = "Prevent seed calls from being run automatically."
  default     = "1"
}

variable "spoke_suppress_self_invite" {
  description = "Prevent users from being able to create organizations."
  default     = "1"
}

variable "spoke_session_secret" {
  description = "Session secret."
  default     = ""
}

variable "spoke_timezone" {
  description = "Timezone that Spoke is operating in."
  default     = "America/New_York"
}

variable "spoke_lambda_debug" {
  description = "Lambda debug flag."
  default     = "0"
}


# SMS

variable "spoke_default_service" {
  description = "The SMS service to use."
  default     = "twilio"
}

## Twilio

variable "spoke_twilio_account_sid" {
  description = "Twilio Account SID."
  default     = ""
}

variable "spoke_twilio_auth_token" {
  description = "Twilio auth token."
  default     = ""
}

variable "spoke_twilio_message_service_sid" {
  description = "Twilio Message Service SID."
  default     = ""
}

## Nexmo

variable "spoke_nexmo_api_key" {
  description = "Nexmo API key."
  default     = ""
}

variable "spoke_nexmo_api_secret" {
  description = "Nexmo API secret."
  default     = ""
}


# Auth0

variable "spoke_auth0_domain" {
  description = "Auth0 domain."
  default     = "domain.auth0.com"
}

variable "spoke_auth0_client_id" {
  description = "Auth0 client ID."
  default     = ""
}

variable "spoke_auth0_client_secret" {
  description = "Auth0 client secret."
  default     = ""
}


# Email

## SMTP

variable "spoke_email_host" {
  description = "Email host."
  default     = ""
}

variable "spoke_email_host_port" {
  description = "Email host port."
  default     = ""
}

variable "spoke_email_host_user" {
  description = "Email host username."
  default     = ""
}

variable "spoke_email_host_password" {
  description = "Email host password."
  default     = ""
}

variable "spoke_email_from" {
  description = "Address to send emails from."
  default     = ""
}

## Mailgun

variable "spoke_mailgun_api_key" {
  description = "Mailgun API key."
  default     = ""
}

variable "spoke_mailgun_domain" {
  description = "Mailgun domain."
  default     = ""
}

variable "spoke_mailgun_public_key" {
  description = "Mailgun public key."
  default     = ""
}

variable "spoke_mailgun_smtp_login" {
  description = "Mailgun SMTP login username."
  default     = ""
}

variable "spoke_mailgun_smtp_password" {
  description = "Mailgun SMTP login password."
  default     = ""
}

variable "spoke_mailgun_smtp_port" {
  description = "Mailgun SMTP port."
  default     = "587"
}

variable "spoke_mailgun_smtp_server" {
  description = "Mailgun SMTP host."
  default     = "smtp.mailgun.org"
}


# Action Handlers

variable "spoke_action_handlers" {
  description = "Enabled Action Handlers."
  default     = ""
}

## ActionKit

variable "spoke_ak_baseurl" {
  description = "ActionKit base URL."
  default     = ""
}

variable "spoke_ak_secret" {
  description = "ActionKit secret."
  default     = ""
}


# Rollbar

variable "spoke_rollbar_client_token" {
  description = "Rollbar client token."
  default     = ""
}

variable "spoke_rollbar_endpoint" {
  description = "Rollbar endpoint."
  default     = "https://api.rollbar.com/api/1/item/"
}
