#
# Подключение к тененту vCloud Director
# Переменные определяем в файле variables.tf
#

provider "vcd" {
  user     = var.vCDLogin
  password = var.vCDPassword
  org      = var.vCDOrg
  vdc      = var.vCDvDC
  url      = var.vCDUrl
}

terraform {
  required_providers {
    vcd = {
      source = "vmware/vcd"
    }
  }
 backend "s3" {
    endpoint = "obs.ru-moscow-1.hc.sbercloud.ru"
    bucket  = "state"
    key     = "vcd/terraform.tfstate"
    region  = "ru-moscow-1"
    skip_region_validation      = true
    skip_credentials_validation = true
    access_key   = "DYOM3ILHOUSJGBUVD99A"
    secret_key   = "pJ2piJ33d6zTGHYO0hSOMNQR2vSnOHV4wXW7qj8Q"
  }

}
