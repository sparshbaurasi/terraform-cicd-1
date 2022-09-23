terraform {
  backend "s3" {
    bucket = "tf-state-bucket1"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}