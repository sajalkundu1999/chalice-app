provider "aws" {
  access_key = "AKIAWGT542EKMYHYIHUM"
  secret_key = "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"
  region     = "us-west-2"
}

# Define the virtual machine resource aws
resource "aws_instance" "chalice-app" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "chalice-app"
  }
}

