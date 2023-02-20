terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  region = "us-east-1"
}

provider "random" {
  # Configuration options
}