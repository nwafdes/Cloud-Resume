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


module "Cloud_Resume" {
  source = "../../../CRM-Module"
  table_name = "My_Web_Visitors"
  hash_key =  "id"
  item_name = "Website_Visitors"
  attr_name = "visitors"
  Lambda_function_Name = "differnt_function"
  policy_name = "allow_edit_DDB_Table"
  role_name = "allow_lambda_assume"
  api_name = "FirstTerraformAPI"
  myregion = "us-east-1"
  resource_name = "visitors"
}