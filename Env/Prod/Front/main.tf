# Providers specify which cloud you want to deal with, so terraform can download the necessary tools
provider "aws" {
    region = "us-east-1"
}

terraform {
  required_providers {
    # aws is a local name that should be unique and will be used across the module.
    #best practice = use localname same as the type hashicorp/aws aws here is the type
    aws = {
        source = "hashicorp/aws"
        # the version of aws provider plugin to choose in this module
        version = ">= 1.0"
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