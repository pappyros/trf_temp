resource "aws_s3_bucket" "lohan_terraform_state" {
  bucket        = "lohan-terraform-state"
  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_dynamodb_table" "lohan_terraform_lock" {
  name           = "lohan-terraform-lock"
  hash_key       = "LockID"
  read_capacity  = 2
  write_capacity = 2

  attribute {
    name = "LockID"
    type = "S"
  }
}