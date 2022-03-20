output "invokation_url" {
  description = "Invokation url"

  value = aws_apigatewayv2_stage.production.invoke_url
}

output "integration_route" {
  description = "Integration route"

  value = aws_apigatewayv2_route.hello_world_api_gateway_route.route_key
}

output "log_group_api_gateway" {
  description = "Api Gateway log group"

  value = aws_cloudwatch_log_group.api_gateway_log_group.name
}
