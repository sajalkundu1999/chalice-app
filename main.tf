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

resource "aws_s3_bucket" "chalice_bucket" {
  bucket = "chalice"  # Replace with your desired bucket name
}

resource "aws_s3_bucket_object" "chalice_code" {
  bucket = aws_s3_bucket.chalice_bucket.id
  key    = "chalice_code.zip"
  source = "path/to/your/chalice_code.zip"  # Replace with the path to your Chalice code ZIP file

  depends_on = [aws_s3_bucket.chalice_bucket]
}

