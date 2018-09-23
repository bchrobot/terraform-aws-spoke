# Spoke Deployment Output
# 
# Print information about the resources created. These values will be needed
# in the Claudia.js deploy command.
# 
# Source: https://www.terraform.io/intro/getting-started/outputs.html

output "rds_host_address" {
  description = "RDS Host Address"
  value       = "${module.postgres.address}"
}

output "api_url" {
  description = "Base API Gateway URL. Needed to set DNS record."
  value       = "${module.api_gateway.gateway_url}"
}

output "bundle_hash" {
  description = "The bundle hash for ease of reployment without rebuilding source."
  value       = "${var.client_bundle_hash}"
}

output "s3_bucket_name" {
  description = "S3 Bucket Name"
  value       = "${var.spoke_domain}"
}
