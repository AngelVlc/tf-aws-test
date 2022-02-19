data "archive_file" "lambda_hello_world_zip" {
  type = "zip"

  source_dir  = "${path.module}/../.aws-sam/build/HelloWorldFunction"
  output_path = "${path.module}/hello-world.zip"
}

resource "random_pet" "random_pet_lambda_deploy_bucket" {
  prefix = "lambda-hello-world-deploy"
  length = 4
}

resource "aws_s3_bucket" "lambda_hello_world_deploy_bucket" {
  bucket = random_pet.random_pet_lambda_deploy_bucket.id

  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket_object" "lambda_hello_world_deploy_bucket_object" {
  bucket = aws_s3_bucket.lambda_hello_world_deploy_bucket.id

  key    = "hello-world.zip"
  source = data.archive_file.lambda_hello_world_zip.output_path

  etag = filemd5(data.archive_file.lambda_hello_world_zip.output_path)
}

resource "aws_lambda_function" "hello_world_lambda" {
  function_name = "HelloWorld"

  s3_bucket = aws_s3_bucket.lambda_hello_world_deploy_bucket.id
  s3_key    = aws_s3_bucket_object.lambda_hello_world_deploy_bucket_object.key

  runtime = "go1.x"
  handler = "hello-world"

  source_code_hash = data.archive_file.lambda_hello_world_zip.output_base64sha256

  role = aws_iam_role.hello_world_lambda_execution_role.arn

  tags = var.additional_tags
}

resource "aws_lambda_permission" "lambda_hello_world_api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.hello_world_api_gateway.execution_arn}/*/*"
}