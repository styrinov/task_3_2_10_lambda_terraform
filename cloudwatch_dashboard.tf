resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.env}-${var.lambda_function_name}"
  retention_in_days = 14

  tags = {
    Name = "${var.env}-${var.lambda_function_name}-log-group"
  }
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.env}-api-monitoring"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0, y = 0, width = 6, height = 6,
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", var.lambda_function_name]
          ],
          title  = "Lambda Invocations",
          region = var.region
        }
      },
      {
        type = "metric",
        x    = 6, y = 0, width = 6, height = 6,
        properties = {
          metrics = [
            ["AWS/Lambda", "Throttles", "FunctionName", var.lambda_function_name]
          ],
          title  = "Lambda Throttles",
          region = var.region
        }
      },
      {
        type = "metric",
        x    = 0, y = 6, width = 6, height = 6,
        properties = {
          metrics = [
            ["AWS/Lambda", "ConcurrentExecutions", "FunctionName", var.lambda_function_name]
          ],
          title  = "Concurrent Executions",
          region = var.region
        }
      },
      {
        type = "metric",
        x    = 6, y = 6, width = 6, height = 6,
        properties = {
          metrics = [
            ["AWS/Lambda", "MaxMemoryUsed", "FunctionName", var.lambda_function_name]
          ],
          title  = "Memory Usage (Max)",
          region = var.region
        }
      },
      {
        type = "metric",
        x    = 0, y = 12, width = 6, height = 6,
        properties = {
          metrics = [
            ["AWS/Lambda", "Duration", "FunctionName", var.lambda_function_name]
          ],
          title  = "Billed Duration",
          region = var.region
        }
      },
      {
        type = "metric",
        x    = 6, y = 12, width = 6, height = 6,
        properties = {
          metrics = [
            ["AWS/Lambda", "InitDuration", "FunctionName", var.lambda_function_name]
          ],
          title  = "Cold Starts (Init Duration)",
          region = var.region
        }
      },
      {
        type = "metric",
        x    = 0, y = 18, width = 6, height = 6,
        properties = {
          metrics = [
            ["AWS/ApiGateway", "5XXError", "ApiId", aws_apigatewayv2_api.http_api.id]
          ],
          title  = "API Gateway 5XX Errors",
          region = var.region
        }
      },
      {
        type = "metric",
        x    = 6, y = 18, width = 6, height = 6,
        properties = {
          metrics = [
            ["AWS/ApiGateway", "4XXError", "ApiId", aws_apigatewayv2_api.http_api.id]
          ],
          title  = "API Gateway 4XX Errors",
          region = var.region
        }
      },
     {
        type = "metric",
        x    = 0, y = 24, width = 6, height = 6,
        properties = {
          metrics = [
            [
              "AWS/ApiGateway",
              "2XX",
              "ApiId",
              aws_apigatewayv2_api.http_api.id
            ]
          ],
          title  = "API Gateway 2XX Responses",
          region = var.region
        }
      },
      {
        type = "metric",
        x    = 6, y = 24, width = 6, height = 6,
        properties = {
          metrics = [
            ["AWS/ApiGateway", "Latency", "ApiId", aws_apigatewayv2_api.http_api.id]
          ],
          title  = "API Gateway Latency",
          region = var.region
        }
      },
      {
        type = "metric",
        x    = 0, y = 30, width = 6, height = 6,
        properties = {
          metrics = [
            ["AWS/ApiGateway", "ThrottleCount", "ApiId", aws_apigatewayv2_api.http_api.id]
          ],
          title  = "Throttled Requests",
          region = var.region
        }
      },
      {
        type = "metric",
        x    = 6, y = 30, width = 6, height = 6,
        properties = {
          metrics = [
            ["AWS/ApiGateway", "DataProcessed", "ApiId", aws_apigatewayv2_api.http_api.id]
          ],
          title  = "Data Processed",
          region = var.region
        }
      },
      {
        type = "metric",
        x    = 6, y = 6, width = 6, height = 6,
        properties = {
          metrics = [
            ["AWS/DynamoDB", "ConsumedReadCapacityUnits", "TableName", var.dynamodb_table_name]
          ],
          title  = "DynamoDB Read Capacity",
          region = var.region
        }
      },
      {
        type = "metric",
        x    = 0, y = 12, width = 6, height = 6,
        properties = {
          metrics = [
            ["AWS/DynamoDB", "ConsumedWriteCapacityUnits", "TableName", var.dynamodb_table_name]
          ],
          title  = "DynamoDB Write Capacity",
          region = var.region
        }
      },
      {
        type = "metric",
        x    = 6, y = 12, width = 6, height = 6,
        properties = {
          metrics = [
            ["AWS/DynamoDB", "SuccessfulRequestLatency", "TableName", var.dynamodb_table_name]
          ],
          title  = "DynamoDB Successful Request Latency",
          region = var.region
        }
      }

    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "lambda_throttles" {
  alarm_name          = "${var.env}-lambda-${var.lambda_function_name}-throttles"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Lambda is being throttled"
  treat_missing_data  = "notBreaching"
  dimensions = {
    FunctionName = var.lambda_function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_concurrent_exec" {
  alarm_name          = "${var.env}-lambda-${var.lambda_function_name}-concurrent"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ConcurrentExecutions"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Maximum"
  threshold           = 80 # adjust based on limits
  treat_missing_data  = "notBreaching"
  alarm_description   = "Lambda concurrent executions high"
  dimensions = {
    FunctionName = var.lambda_function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_memory" {
  alarm_name          = "${var.env}-lambda-${var.lambda_function_name}-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "MaxMemoryUsed"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Maximum"
  threshold           = 120000000 # ~120MB
  treat_missing_data  = "notBreaching"
  alarm_description   = "Lambda memory usage high"
  dimensions = {
    FunctionName = var.lambda_function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_init_duration" {
  alarm_name          = "${var.env}-lambda-${var.lambda_function_name}-cold-starts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "InitDuration"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Average"
  threshold           = 300 # in milliseconds
  treat_missing_data  = "notBreaching"
  alarm_description   = "Lambda cold starts detected"
  dimensions = {
    FunctionName = var.lambda_function_name
  }
}


resource "aws_cloudwatch_metric_alarm" "api_5xx" {
  alarm_name          = "${var.env}-api-${var.api_gateway_name}-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "API Gateway is returning 5XX errors"
  treat_missing_data  = "notBreaching"
  dimensions = {
    ApiName = var.api_gateway_name
  }
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_read_capacity" {
  alarm_name          = "${var.env}-dynamodb-${var.dynamodb_table_name}-read-capacity"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ConsumedReadCapacityUnits"
  namespace           = "AWS/DynamoDB"
  period              = 300
  statistic           = "Sum"
  threshold           = 1000 # Adjust based on provisioned capacity
  alarm_description   = "High DynamoDB read capacity consumption"
  treat_missing_data  = "notBreaching"
  dimensions = {
    TableName = var.dynamodb_table_name
  }
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_write_capacity" {
  alarm_name          = "${var.env}-dynamodb-${var.dynamodb_table_name}-write-capacity"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ConsumedWriteCapacityUnits"
  namespace           = "AWS/DynamoDB"
  period              = 300
  statistic           = "Sum"
  threshold           = 1000 # Adjust based on provisioned capacity
  alarm_description   = "High DynamoDB write capacity consumption"
  treat_missing_data  = "notBreaching"
  dimensions = {
    TableName = var.dynamodb_table_name
  }
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_latency" {
  alarm_name          = "${var.env}-dynamodb-${var.dynamodb_table_name}-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "SuccessfulRequestLatency"
  namespace           = "AWS/DynamoDB"
  period              = 300
  statistic           = "Average"
  threshold           = 300 # in milliseconds
  alarm_description   = "High latency for successful DynamoDB requests"
  treat_missing_data  = "notBreaching"
  dimensions = {
    TableName = var.dynamodb_table_name
  }
}
