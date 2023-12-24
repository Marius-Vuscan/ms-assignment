terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.85.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.42.0"
    }
  }

  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}

provider "github" {
}

