provider "aws" {
  access_key = "AKIAWGT542EKMYHYIHUM"
  secret_key = "wygdbokqw+q/Nvyc7jeoJeSg7wZ7mQq8hdr1liRq"
  region     = "us-west-2"
}


resource "aws_s3_bucket" "my_bucket" {
  bucket = "chalice"  # Update with your desired bucket name
  acl    = "private"  # Update with the desired access control list
}

resource "aws_lambda_function" "my_lambda" {
  function_name    = "my-lambda"  # Update with your desired Lambda function name
  role             = aws_iam_role.my_lambda_role.arn
  handler          = "app.app"
  runtime          = "python3.8"  # Update with your desired runtime
  filename         = "lambda.zip"  # Update with the filename of your Lambda deployment package
  source_code_hash = filebase64sha256("lambda.zip")
}

resource "aws_iam_role" "my_lambda_role" {
  name = "my-lambda-role"  # Update with your desired IAM role name

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

resource "aws_iam_policy_attachment" "my_lambda_policy_attachment" {
  name       = "my-lambda-policy-attachment"
  roles      = [aws_iam_role.my_lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"  # Update with the desired IAM policy ARN
}


