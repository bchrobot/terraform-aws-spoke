# Spoke Deployment Output
# 
# Print information about the resources created. These values will be needed
# in the Claudia.js deploy command.
# 
# Source: https://www.terraform.io/intro/getting-started/outputs.html

output "RDS Host" {
  value = "${aws_db_instance.spoke.address}"
}

output "Bundle Hash" {
  value = "${var.bundle_hash}"
}

output "S3 Bucket Name" {
  value = "${var.spoke_domain}"
}

output "Base API Gateway URL" {
  value = "${aws_api_gateway_deployment.spoke.invoke_url}"
}
