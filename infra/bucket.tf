resource "aws_s3_bucket" "example" {
  bucket = "deborah-qe-test-bucket" #change to your unique bucket name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
