terraform {
  required_providers {
    aws = ">=3.67.0"
  }

  backend "s3" {
    bucket         = "dsr-terraform-states"
    key            = "language-recognize/ecr.tfstate"
    region         = "us-west-2"
    dynamodb_table = "dsr-terraform-lock"
  }
}

provider "aws" {
  region = "us-west-2"
}
