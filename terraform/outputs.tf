output "api_endpoint" {
  description = "Public HTTPS URL for the POST /shorten endpoint on the dev stage."
  value       = "${aws_api_gateway_stage.dev.invoke_url}/shorten"
}
