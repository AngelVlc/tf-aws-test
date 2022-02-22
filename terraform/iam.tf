resource "aws_iam_role" "hello_world_lambda_execution_role" {
  name = "serverless_lambda"
  tags = var.additional_tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "hello_world_lambda_execution_policy_attachment" {
  role       = aws_iam_role.hello_world_lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
