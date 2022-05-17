provider "aws" {
  version = "4.12.1"
  # access_key = "$access_key"
  # secret_key = "$secret_key"
  region = "ap-northeast-2"
}

terraform {
  backend "s3" {
    bucket         = "lohan-terraform-state"
    key            = "terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "lohan-terraform-lock"
  }
}