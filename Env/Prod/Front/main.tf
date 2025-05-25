# Providers specify which cloud you want to deal with, so terraform can download the necessary tools
provider "aws" {
    region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "sahaba-cloudresume-challenge-tfstate" # REPLACE WITH YOUR BUCKET NAME
    key            = "03-basics/frontend-bootstrap/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "sahaba-terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

variable "files" {
  type = list(string)
  default = [ "about.html", "stylesheet.css", "interactive.js"]
}

module "front_end" {
  source = "../../../Front_End"
  bucket_name = "nawafdes-cloud-resume-challenge"
}