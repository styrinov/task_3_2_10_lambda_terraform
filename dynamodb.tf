module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "4.4.0"

  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]

  tags = {
    Name = var.dynamodb_table_name
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "http-crud-tutorial-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}