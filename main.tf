terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "overloading_of_resources_in_apache_airflow" {
  source    = "./modules/overloading_of_resources_in_apache_airflow"

  providers = {
    shoreline = shoreline
  }
}