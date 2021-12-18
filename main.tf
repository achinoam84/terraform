#
# Configure the SberCloud Provider
#
terraform {
  required_providers {
    sbercloud = {
      source = "sbercloud-terraform/sbercloud"
    }
  }
}

provider "sbercloud" {
  auth_url = "https://iam.ru-moscow-1.hc.sbercloud.ru/v3"
  region   = "ru-moscow-1"

  access_key   = var.access_key
  secret_key   = var.secret_key
  account_name  = var.AccountName
  project_name = var.iam_project_name
}
