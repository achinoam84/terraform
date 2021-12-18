#
# Создание подсетей, NAT, VPN согласно количеству и параметрам, указанным в файле variables.tf
# Ничего не менять
#
#
# Сначала создаем виртуальный клауд VPC (маршрутизатор)
#
resource "sbercloud_vpc" "vpc_01" {
  count               = var.VPCCount
  name                = var.VpcName
  cidr                = var.VpcCidr
}
#
# Создаем виртуальные подсети в созданном клауде
#
resource "sbercloud_vpc_subnet" "subnet_01" {
  count          = var.NetCount
  name           = var.NETs[count.index].NetName
  cidr           = var.NETs[count.index].NetV4
  gateway_ip     = var.NETs[count.index].NetGateway
  dhcp_enable    = "true"
  primary_dns    = "100.125.13.59"
  secondary_dns  = "8.8.8.8"
  vpc_id         = sbercloud_vpc.vpc_01[0].id
   
  depends_on = [sbercloud_vpc.vpc_01[0]]
}
#
# Create EIP for NAT Gateway
resource "sbercloud_vpc_eip" "nat_eip" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "nat_bandwidth"
    size        = 4
    share_type  = "PER"
    charge_mode = "bandwidth"
  }
}
# Добавляем NAT
#
resource "sbercloud_nat_gateway" "nat_01" {
  count               = var.NATCount
  name                = "${var.VpcName}-NAT"
  description         = "NAT для маршрутизатора ${var.VpcName}"
  spec                = var.NATType
  vpc_id              = sbercloud_vpc.vpc_01[count.index].id
  subnet_id           = sbercloud_vpc_subnet.subnet_01[count.index].id
   
  depends_on = [sbercloud_vpc_subnet.subnet_01[0]]
}
#resource "huaweicloud_networking_floatingip_v2" "floatip_scm" {
 # count     = var.NATCount
  # 
 # depends_on = [huaweicloud_nat_gateway_v2.nat_scm]
#}
resource "sbercloud_nat_snat_rule" "snat_subnet_01" {
  count          = var.NetCount
  nat_gateway_id = sbercloud_nat_gateway.nat_01[0].id
  subnet_id      = sbercloud_vpc_subnet.subnet_01[count.index].id
  floating_ip_id = sbercloud_vpc_eip.nat_eip.id
   
  #depends_on = [huaweicloud_networking_floatingip_v2.floatip_scm,huaweicloud_nat_gateway_v2.nat_scm]
}
