terraform {
  backend "s3" {
    bucket = "ts-academy-storage"
    key    = "tf-academy.tfstate"
    region = var.aws_region
  }
}
