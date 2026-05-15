resource "aws_api_gateway_rest_api" "shortener_api" {
  name        = "shortener_api"
  description = "Linkflow URL Shortener REST API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "shorten_resource" {
  rest_api_id = aws_api_gateway_rest_api.shortener_api.id
  parent_id   = aws_api_gateway_rest_api.shortener_api.root_resource_id
  path_part   = "shorten"
}

resource "aws_api_gateway_method" "post_shorten" {
  rest_api_id   = aws_api_gateway_rest_api.shortener_api.id
  resource_id   = aws_api_gateway_resource.shorten_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_shorten_integration" {
  rest_api_id             = aws_api_gateway_rest_api.shortener_api.id
  resource_id             = aws_api_gateway_resource.shorten_resource.id
  http_method             = aws_api_gateway_method.post_shorten.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.shortener_lambda.invoke_arn
}

resource "aws_api_gateway_method" "options_shorten" {
  rest_api_id   = aws_api_gateway_rest_api.shortener_api.id
  resource_id   = aws_api_gateway_resource.shorten_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_shorten_integration" {
  rest_api_id = aws_api_gateway_rest_api.shortener_api.id
  resource_id = aws_api_gateway_resource.shorten_resource.id
  http_method = aws_api_gateway_method.options_shorten.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({ statusCode = 200 })
  }
}

resource "aws_api_gateway_method_response" "options_shorten_200" {
  rest_api_id = aws_api_gateway_rest_api.shortener_api.id
  resource_id = aws_api_gateway_resource.shorten_resource.id
  http_method = aws_api_gateway_method.options_shorten.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "options_shorten_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.shortener_api.id
  resource_id = aws_api_gateway_resource.shorten_resource.id
  http_method = aws_api_gateway_method.options_shorten.http_method
  status_code = aws_api_gateway_method_response.options_shorten_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST, OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }

  depends_on = [aws_api_gateway_integration.options_shorten_integration]
}

resource "aws_api_gateway_deployment" "shortener_deployment" {
  rest_api_id = aws_api_gateway_rest_api.shortener_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.shorten_resource.id,
      aws_api_gateway_method.post_shorten.id,
      aws_api_gateway_integration.post_shorten_integration.id,
      aws_api_gateway_method.options_shorten.id,
      aws_api_gateway_integration.options_shorten_integration.id,
      aws_api_gateway_integration_response.options_shorten_integration_response.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.post_shorten,
    aws_api_gateway_integration.post_shorten_integration,
    aws_api_gateway_method.options_shorten,
    aws_api_gateway_integration.options_shorten_integration,
    aws_api_gateway_integration_response.options_shorten_integration_response,
  ]
}

resource "aws_api_gateway_stage" "dev" {
  rest_api_id   = aws_api_gateway_rest_api.shortener_api.id
  deployment_id = aws_api_gateway_deployment.shortener_deployment.id
  stage_name    = "dev"
}


resource "aws_lambda_permission" "apigw_invoke_shortener" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.shortener_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.shortener_api.execution_arn}/*/POST/shorten"
}
