
#===========Only as sample================================
module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.0"

  function_name = "hello-lambda"
  description   = "Lambda function using prebuilt module"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  memory_size   = 128
  timeout       = 10

  source_path = "./src"

  create_role              = true
  attach_policy_statements = true

  policy_statements = [
    {
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:aws:logs:*:*:*"]
    }
  ]
}

#==========================================================
# Lambda Function
module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.0"

  function_name = "http-crud-tutorial-function"
  description   = "CRUD API for DynamoDB"
  handler       = "main.lambda_handler"
  runtime       = "python3.12"
  memory_size   = 128
  timeout       = 10

  source_path = "./lambda/python"

  create_role              = true
  attach_policy_statements = true

  policy_statements = [
    {
      actions   = ["logs:*"]
      resources = ["arn:aws:logs:*:*:*"]
    },
    {
      actions   = ["dynamodb:*"]
      resources = ["*"]
    }
  ]

  environment_variables = {
    TABLE_NAME = "http-crud-tutorial-items"
  }
}
