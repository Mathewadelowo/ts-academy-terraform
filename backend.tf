terraform {
  backend "s3" {
    bucket       = "my-company-terraform-state"
    key          = "infrastructure/terraform.tfstate"
    region       = "us-east-1"
  }
}