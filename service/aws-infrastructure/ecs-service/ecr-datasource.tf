data "terraform_remote_state" "ecr_data" {
  backend = "s3"

  config = {
    bucket = "dsr-terraform-states"
    key    = "language-recognize/ecr.tfstate"
    region = "us-west-2"
  }
}
