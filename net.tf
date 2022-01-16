#
# Создание подсетей согласно количеству и параметрам, указанным в файле variables.tf
# Ничего не менять
#
resource "vcd_network_routed" "net" {
  count          = var.NetCount
  name           = var.NETs[count.index].NetName
  edge_gateway   = var.EdgeName
  gateway        = var.NETs[count.index].NetGateway
  netmask        = var.NETs[count.index].NetNetmask
  interface_type = var.NETs[count.index].NetInterfaceType
  dns1           = var.NETs[count.index].NetDns1
  dns2           = var.NETs[count.index].NetDns2
#  dhcp_pool {
#   start_address = var.NETs[count.index].DHCPStartAddress
#   end_address   = var.NETs[count.index].DHCPEndAddress
#  }
}

#
# Создание правил SNAT для создаваемых подсетей для выхода в Интернет
#
resource "vcd_nsxv_snat" "web" {
  count              = var.NetCount
  edge_gateway       = var.EdgeName
  network_type       = "ext"
  network_name       = var.EdgeExt
  original_address   = var.NETs[count.index].NetV4
  translated_address = var.EdgeIP
}
#
# Создание правил FW для создаваемых подсетей для выхода в Интернет
#
resource "vcd_nsxv_firewall_rule" "Rules" {
  count          = var.NetCount
  edge_gateway   = var.EdgeName
  name           = "${var.NETs[count.index].NetName} Internet Access"
  source {
    ip_addresses = [var.NETs[count.index].NetV4]
  }
  destination {
    ip_addresses = ["any"]
  }
  service {
    protocol = "any"
  }
}
