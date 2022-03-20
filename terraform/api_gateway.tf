resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "lambda_hello_world"
  protocol_type = "HTTP"
  tags          = local.tags
}

resource "aws_apigatewayv2_stage" "production" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  name        = "lambda_hello_world_production_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_log_group.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "api_gateway_integration" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_uri    = aws_lambda_function.lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "hello_world_api_gateway_route" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.api_gateway_integration.id}"
}
