resource "aws_iam_role" "role" {
  name = var.role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_lambda_function" "lambda" {
  function_name    = var.lambda_name
  filename         = var.lambda_filename
  role             = aws_iam_role.role.arn
  handler          = var.lambda_handler
  source_code_hash = filebase64sha256(var.lambda_filename)
  runtime          = var.lambda_runtime
  layers           = [aws_lambda_layer_version.layer.arn]
  environment {
    variables = local.environment
  }
  timeout    = var.lambda_timeout
  depends_on = [aws_iam_role_policy_attachment.attachment, aws_cloudwatch_log_group.cw_group]
}

resource "aws_lambda_layer_version" "layer" {
  filename   = var.layer_filename
  layer_name = var.layer_name

  compatible_runtimes = var.layer_runtimes
}

resource "aws_lambda_permission" "permission" {
  function_name = aws_lambda_function.lambda.function_name
  action        = var.permission_action
  principal     = var.permission_principal

  depends_on = [aws_lambda_function.lambda]
}

resource "aws_cloudwatch_log_group" "cw_group" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = var.logs_retention
}

resource "aws_iam_policy" "policy" {
  name = var.policy_name
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": ${jsonencode(concat(local.logging_policy, var.policies))}
}
EOF

}

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
