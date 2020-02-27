locals {
  environment = merge(
    var.lambda_variables,
    {
      "FUNCTION_NAME" = var.lambda_name
    },
    {
      "FUNCTION_TIMEOUT" = var.lambda_timeout
    },
  )
  logging_policy = [
    {
      Action = [
        "logs:PutLogEvents"
      ]
      Resource = [
        "arn:aws:logs:${var.region}:${var.profile}:log-group:/aws/lambda/${var.lambda_name}:*:*"
      ]
      Effect = "Allow"
    }
  ]
}
