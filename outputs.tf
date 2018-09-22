# Spoke Deployment Output
# 
# Print information about the resources created. These values will be needed
# in the Claudia.js deploy command.
# 
# Source: https://www.terraform.io/intro/getting-started/outputs.html

output "RDS Host Address" {
  value = "${module.postgres.address}"
}

output "Bundle Hash" {
  value = "${var.client_bundle_hash}"
}

output "S3 Bucket Name" {
  value = "${var.spoke_domain}"
}

output "Base API Gateway URL" {
  value = "${module.api_gateway.gateway_url}"
}
