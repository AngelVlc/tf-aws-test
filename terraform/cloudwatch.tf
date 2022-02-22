resource "aws_cloudwatch_log_group" "hello_world_api_gateway_log_group" {
  name              = "/aws/api_gw/${aws_apigatewayv2_api.hello_world_api_gateway.name}"
  tags              = var.additional_tags
  retention_in_days = 5
}