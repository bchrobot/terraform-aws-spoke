output "gateway_url" {
  description = "The URL of the API gateway."
  value       = "${aws_api_gateway_deployment.spoke.invoke_url}"
}
