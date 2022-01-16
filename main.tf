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
}
