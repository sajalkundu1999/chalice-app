provider "aws" {
  region = "us-east-1"  # Change to your desired AWS region
}

resource "aws_s3_bucket" "chalice_bucket" {
  bucket = "chalice"  # Replace with your desired bucket name
  acl    = "private"
}

resource "aws_s3_bucket_object" "chalice_app" {
  bucket = aws_s3_bucket.chalice_bucket.id
  key    = "app.py"
  source = "../chalice-app/app.py"  # Path to your Chalice app.py file
}
