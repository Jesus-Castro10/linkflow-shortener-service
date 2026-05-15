resource "aws_iam_role" "shortener_lambda_role" {
  name        = "shortener_lambda_role"
  description = "IAM role assumed by the linkflow shortener Lambda function."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowLambdaAssumeRole"
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "shortener_dynamodb_policy" {
  name        = "shortener_dynamodb_policy"
  description = "Grants the shortener Lambda the minimum DynamoDB permissions it needs."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowShortenerTableAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem"
        ]
        Resource = data.aws_dynamodb_table.shortener_table.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "shortener_dynamodb_attach" {
  role       = aws_iam_role.shortener_lambda_role.name
  policy_arn = aws_iam_policy.shortener_dynamodb_policy.arn
}

resource "aws_iam_role_policy_attachment" "shortener_basic_execution_attach" {
  role       = aws_iam_role.shortener_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
