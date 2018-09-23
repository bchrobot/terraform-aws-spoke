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
  description = "Create a globally unique S3 bucket. Usually the same as spoke_domain: spoke.example.com"
}

variable "rds_password" {
  type        = "string"
  description = "The password for the Postgres instance user."
}

variable "server_bundle_location" {
  description = "Path of packed server.zip"
}

variable "client_bundle_location" {
  description = "Path of compiled bundle.[hash].js"
}

variable "client_bundle_hash" {
  description = "Hash of client bundle.js."
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
