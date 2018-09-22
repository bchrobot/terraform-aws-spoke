# Create Lambda Security Group
# Source: https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "lambda" {
  name        = "lambda"
  description = "Allow all inbound web traffic"
  vpc_id      = "${var.vpc_id}"

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

# Create Lambda Role
# Source: https://www.terraform.io/docs/providers/aws/r/iam_role.html
resource "aws_iam_role" "spoke_lambda" {
  name = "SpokeOnLambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


# Attach Policies to Role
# Source: https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html

# AWSLambdaRole
resource "aws_iam_role_policy_attachment" "aws_lambda" {
    role       = "${aws_iam_role.spoke_lambda.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

# AWSLambdaVPCAccessExecutionRole
resource "aws_iam_role_policy_attachment" "aws_lambda_vpc_access_execution" {
    role       = "${aws_iam_role.spoke_lambda.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# AmazonS3FullAccess
resource "aws_iam_role_policy_attachment" "s3_full_access" {
    role       = "${aws_iam_role.spoke_lambda.name}"
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Inline Policy
# Source: https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
resource "aws_iam_role_policy" "vpc_access_execution" {
  name = "vpc-access-execution"
  role = "${aws_iam_role.spoke_lambda.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VPCAccessExecutionPermission",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeNetworkInterfaces"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}


# Create Lambda function
# Source: https://www.terraform.io/docs/providers/aws/r/lambda_function.html
resource "aws_lambda_function" "spoke" {
  function_name = "Spoke"
  description   = "Spoke P2P Texting Platform"

  s3_bucket         = "${var.s3_bucket_name}"
  s3_key            = "${var.s3_key}"
  source_code_hash  = "${var.source_code_hash}"


  handler     = "lambda.handler"
  runtime     = "nodejs6.10"
  memory_size = "512"
  timeout     = "300"

  role = "${aws_iam_role.spoke_lambda.arn}"

  vpc_config = {
    subnet_ids          = ["${var.subnet_ids}"]
    security_group_ids  = ["${aws_security_group.lambda.id}"]
  }

  environment = {
    variables = {
      NODE_ENV = "production"
      JOBS_SAME_PROCESS = "1"
      SUPPRESS_SEED_CALLS = "${var.spoke_suppress_seed}"
      SUPPRESS_SELF_INVITE = "${var.spoke_suppress_self_invite}"
      AWS_ACCESS_AVAILABLE = "1"
      AWS_S3_BUCKET_NAME = "${var.s3_bucket_name}"
      APOLLO_OPTICS_KEY = ""
      DEFAULT_SERVICE = "${var.spoke_default_service}"
      OUTPUT_DIR = "./build"
      PUBLIC_DIR = "./build/client"
      ASSETS_DIR = "./build/client/assets"
      STATIC_BASE_URL = "https://s3.${var.aws_region}.amazonaws.com/${var.s3_bucket_name}/static/"
      BASE_URL = "https://${var.spoke_domain}"
      S3_STATIC_PATH = "s3://${var.s3_bucket_name}/static/"
      ASSETS_MAP_FILE = "assets.json"
      DB_HOST = "${var.db_host}"
      DB_PORT = "${var.db_port}"
      DB_NAME = "${var.db_name}"
      DB_USER = "${var.db_user}"
      DB_PASSWORD = "${var.db_password}"
      DB_TYPE = "pg"
      DB_KEY = ""
      PGSSLMODE = "require"
      AUTH0_DOMAIN = "${var.spoke_auth0_domain}"
      AUTH0_CLIENT_ID = "${var.spoke_auth0_client_id}"
      AUTH0_CLIENT_SECRET = "${var.spoke_auth0_client_secret}"
      SESSION_SECRET = "${var.spoke_session_secret}"
      NEXMO_API_KEY = "${var.spoke_nexmo_api_key}"
      NEXMO_API_SECRET = "${var.spoke_nexmo_api_secret}"
      TWILIO_API_KEY = "${var.spoke_twilio_account_sid}"
      TWILIO_MESSAGE_SERVICE_SID = "${var.spoke_twilio_message_service_sid}"
      TWILIO_APPLICATION_SID = "${var.spoke_twilio_message_service_sid}"
      TWILIO_AUTH_TOKEN = "${var.spoke_twilio_auth_token}"
      TWILIO_STATUS_CALLBACK_URL = "https://${var.spoke_domain}/twilio-message-report"
      EMAIL_HOST = "${var.spoke_email_host}"
      EMAIL_HOST_PASSWORD = "${var.spoke_email_host_password}"
      EMAIL_HOST_USER = "${var.spoke_email_host_user}"
      EMAIL_HOST_PORT = "${var.spoke_email_host_port}"
      EMAIL_FROM = "${var.spoke_email_from}"
      ROLLBAR_CLIENT_TOKEN = "${var.spoke_rollbar_client_token}"
      ROLLBAR_ACCESS_TOKEN = "${var.spoke_rollbar_client_token}"
      ROLLBAR_ENDPOINT = "${var.spoke_rollbar_endpoint}"
      DST_REFERENCE_TIMEZONE = "${var.spoke_timezone}"
      TZ = "${var.spoke_timezone}"
      ACTION_HANDLERS = "${var.spoke_action_handlers}"
      AK_BASEURL = "${var.spoke_ak_baseurl}"
      AK_SECRET = "${var.spoke_ak_secret}"
      MAILGUN_API_KEY = "${var.spoke_mailgun_api_key}"
      MAILGUN_DOMAIN = "${var.spoke_mailgun_domain}"
      MAILGUN_PUBLIC_KEY = "${var.spoke_mailgun_public_key}"
      MAILGUN_SMTP_LOGIN = "${var.spoke_mailgun_smtp_login}"
      MAILGUN_SMTP_PASSWORD = "${var.spoke_mailgun_smtp_password}"
      MAILGUN_SMTP_PORT = "${var.spoke_mailgun_smtp_port}"
      MAILGUN_SMTP_SERVER = "${var.spoke_mailgun_smtp_server}"
      LAMBDA_DEBUG_LOG = "${var.spoke_lambda_debug}"
    }
  }
}
