terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.0.0"
  
  # Uncomment this block to use S3 backend
  # backend "s3" {
  #   bucket         = "infra-c-terraform-state"
  #   key            = "terraform-aws-project/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Terraform-AWS-Project"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}