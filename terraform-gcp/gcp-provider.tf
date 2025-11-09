// Setup providers
terraform {
	required_providers {
		random = {
          source  = "hashicorp/random"
          version = "3.6.3"
		}
		google = {
          source  = "hashicorp/google"
          version = "6.13.0"
		}
	}
}

// Setup GCP provider and project name
provider "google" {
	project = var.project_name
}

// Variable for project name - set in tfvars
variable "project_name" {
	type = string
}

// Variable for region - set in tfvars
variable "region" {
	type = string
}