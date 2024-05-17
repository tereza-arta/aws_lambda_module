output "iam_role" {
    value = aws_iam_role.for-lambda.name
}

output "lf_arn" {
    value = aws_lambda_function.tf-lambda-func.arn
}


output "lf_name" {
    value = aws_lambda_function.tf-lambda-func.function_name
}

/*
output "env_var" {
    value = aws_lambda_function.tf-lambda-func.environment[0]
}
*/
