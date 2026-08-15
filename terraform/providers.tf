terraform {
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Utilise le profil AWS CLI dédié "meditrack" (créé en Q1) plutôt que le profil
# default, conformément au principe du moindre privilège.
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
