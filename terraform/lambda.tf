resource "aws_lambda_function" "lambda" {
  function_name = "HelloWorld"

  s3_bucket = aws_s3_bucket.lambda_deploy_bucket.id
  s3_key    = aws_s3_object.lambda_deploy_bucket_object.key

  runtime = "go1.x"
  handler = "hello-world"

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role = aws_iam_role.lambda_execution_role.arn

  tags = local.tags
}

resource "aws_lambda_permission" "lambda_api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}
