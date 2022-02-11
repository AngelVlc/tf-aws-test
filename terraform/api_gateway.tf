resource "aws_apigatewayv2_api" "lambda" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"
  tags          = var.additional_tags
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

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

resource "aws_apigatewayv2_integration" "hello_world" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.hello_world.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "hello_world" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.hello_world.id}"
}




# resource "aws_api_gateway_rest_api" "api" {
#   name        = "test-api-gateway"
#   description = "Proxy to handle requests to our API"
#   tags        = var.additional_tags
# }

# resource "aws_api_gateway_resource" "resource" {
#   rest_api_id = aws_api_gateway_rest_api.api.id
#   parent_id   = aws_api_gateway_rest_api.api.root_resource_id
#   path_part   = "{proxy+}"
# }

# resource "aws_api_gateway_method" "method" {
#   rest_api_id   = aws_api_gateway_rest_api.api.id
#   resource_id   = aws_api_gateway_resource.resource.id
#   http_method   = "ANY"
#   authorization = "NONE"
#   request_parameters = {
#     "method.request.path.proxy" = true
#   }
# }

# resource "aws_api_gatewayv2_integration" "integration" {
#   rest_api_id             = aws_api_gateway_rest_api.api.id
#   resource_id             = aws_api_gateway_resource.resource.id
#   http_method             = aws_api_gateway_method.method.http_method
#   integration_http_method = "ANY"
#   integration_uri         = aws_lambda_function.hello_world.invoke_arn
#   integration_type                    = "HTTP_PROXY"
#   request_parameters = {
#     "integration.request.path.proxy" = "method.request.path.proxy"
#   }
# }

# resource "aws_api_gateway_deployment" "example" {
#   depends_on = [
#     aws_api_gateway_integration.integration,
#   ]

#   rest_api_id = aws_api_gateway_rest_api.api.id
#   stage_name  = "test"
# }