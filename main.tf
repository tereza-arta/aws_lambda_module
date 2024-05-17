module "lambda-func" {
	source           = "./modules/lambda_function"

	runtime_language = "python3.12"
	func_name        = "tf-lambda-function"
}

resource "aws_iam_policy" "policy" {
  name        = "AccessToCloudWatch"
  description = "Access to CloudWatch"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rp-attach" {
  role       = module.lambda-func.iam_role
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_s3_bucket" "b2" {
  bucket = "bucket-from-tf"
  tags   = {
    Name = "Created by Terraform"
  }
}

resource "aws_s3_bucket_notification" "bn" {
  bucket = aws_s3_bucket.b2.id

  lambda_function {
    lambda_function_arn = module.lambda-func.lf_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow-bucket]
}

resource "aws_lambda_permission" "allow-bucket" {
  statement_id   = "AllowExecutionFromS3Bucket"
  action         = "lambda:InvokeFunction"
  function_name  = module.lambda-func.lf_arn
  principal      = "s3.amazonaws.com"
  source_arn     = aws_s3_bucket.b2.arn
}
