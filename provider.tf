# Configuration du fournisseur (Provider) AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

# C'est ici qu'on définit la région par défaut
provider "aws" {
  region = "eu-west-3" 
}
