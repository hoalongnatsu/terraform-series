data "archive_file" "zip_file_for_lambda_viewer_request" {
  type        = "zip"
  source_file = "function/viewer-request.js"
  output_path = "function/viewer-request.zip"
}

data "archive_file" "zip_file_for_lambda_origin_request" {
  type        = "zip"
  source_file = "function/origin-request.js"
  output_path = "function/origin-request.zip"
}

data "archive_file" "zip_file_for_lambda_origin_response" {
  type        = "zip"
  source_file = "function/origin-response.js"
  output_path = "function/origin-response.zip"
}

provider "aws" {
  region  = "us-east-1"
  alias   = "us-east-1"
}

resource "aws_lambda_function" "viewer_request_function" {
  function_name = "viewer-request-ab-testing"
  role          = aws_iam_role.lambda_edge.arn
  publish       = true

  handler          = "viewer-request.handler"
  runtime          = "nodejs14.x"
  filename         = "function/viewer-request.zip"
  source_code_hash = filebase64sha256("function/viewer-request.zip")

  provider = aws.us-east-1
}

resource "aws_lambda_function" "origin_request_function" {
  function_name = "origin-request-ab-testing"
  role          = aws_iam_role.lambda_edge.arn
  publish       = true

  handler          = "origin-request.handler"
  runtime          = "nodejs14.x"
  filename         = "function/origin-request.zip"
  source_code_hash = filebase64sha256("function/origin-request.zip")

  provider = aws.us-east-1
}

resource "aws_lambda_function" "origin_response_function" {
  function_name = "origin-response-ab-testing"
  role          = aws_iam_role.lambda_edge.arn
  publish       = true

  handler          = "origin-response.handler"
  runtime          = "nodejs14.x"
  filename         = "function/origin-response.zip"
  source_code_hash = filebase64sha256("function/origin-response.zip")

  provider = aws.us-east-1
}
