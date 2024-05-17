locals {
	file_name = "file"
}

resource "aws_iam_role" "for-lambda" {
  name = "role_for_lambda"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "IamRoleForLambda"
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    tag-key = "Role for Lambda Function"
  }
}

data "archive_file" "zip-of-context" {
  type        = "zip"
  source_dir  = "${path.module}/${var.source_dir}/"
  output_path = "${path.module}/${var.source_dir}/${local.file_name}.zip"
}

resource "aws_lambda_function" "tf-lambda-func" {
  filename      = "${path.module}/${var.source_dir}/${local.file_name}.zip"
  function_name = var.func_name
  role          = aws_iam_role.for-lambda.arn
  handler       = "${local.file_name}.lambda_handler"
  runtime       = var.runtime_language

  environment {
    variables = {
      "KEY"        = "some_value"
      "SECOND_KEY" = "second_value"
    }
  }
}
