resource "aws_lambda_function" "shortener_lambda" {
  function_name = "shortener_lambda"
  description   = "Linkflow URL Shortener — creates and resolves short URLs."

  filename         = "../function.zip"
  source_code_hash = filebase64sha256("../function.zip")

  runtime = "nodejs18.x"
  handler = "src/handlers/shortenHandler.handler"

  role = aws_iam_role.shortener_lambda_role.arn

  timeout = 30 

  environment {
    variables = {
      TABLE_NAME  = aws_dynamodb_table.urls_table.name
      BASE_DOMAIN = var.domain
    }
  }
}
