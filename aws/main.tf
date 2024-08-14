terraform {

  required_version = ">=1.4.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.4.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

