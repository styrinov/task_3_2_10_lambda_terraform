output "lambda_function_name" {
  value = module.lambda_function.lambda_function_name
}

output "lambda_function_arn" {
  value = module.lambda_function.lambda_function_arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "http_api_invoke_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

output "api_gateway_custom_domain_url" {
  value = "https://${aws_apigatewayv2_domain_name.custom.domain_name}"
}

output "dynamodb_table_name" {
  value = module.dynamodb_table.dynamodb_table_id
}

