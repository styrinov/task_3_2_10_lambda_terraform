output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}

output "lambda_function_arn" {
  value = module.lambda.lambda_function_arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "http_api_invoke_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

