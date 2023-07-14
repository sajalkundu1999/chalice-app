# provider "aws" {
#   access_key = "AKIAWGT542EKMYHYIHUM"
#   secret_key = "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"
#   region     = "us-west-2"
# }

# # Define the virtual machine resource aws terraform
# resource "aws_instance" "chalice-app" {
#   ami           = "ami-053b0d53c279acc90"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "chalice-app"
#   }
# }


provider "aws" {
  region = "us-west-2"  # Replace with your desired AWS region
}

resource "aws_s3_bucket" "chalice" {
  bucket = "chalice"  # Replace with your desired bucket name
}

resource "aws_lambda_function" "chalice_lambda" {
  function_name = "my-chalice-lambda"  # Replace with your desired Lambda function name
  role          = aws_iam_role.chalice_lambda_role.arn
  handler       = "app.app"
  runtime       = "python3.8"
  filename      = "deployment.zip"
  source_code_hash = filebase64sha256("deployment.zip")
}

resource "aws_iam_role" "chalice_lambda_role" {
  name = "my-chalice-lambda-role"  # Replace with your desired role name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
