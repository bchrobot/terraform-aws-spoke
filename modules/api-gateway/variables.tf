variable "invoke_arn" {
  type = "string"
  description = "The gateway's target Lambda function invoke ARN. Example: aws_lambda_function.spoke.invoke_arn"
}

variable "function_arn" {
  type = "string"
  description = "The gateway's target Lambda function ARN. Example: aws_lambda_function.spoke.arn"
}
