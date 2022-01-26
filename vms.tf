#
# Создаем контейнеры и ВМ в количестве, определяемом в переменной var.VMCount
# В одном контейнере vApp - одна ВМ
# Все необходимые параметры определяем в файле переменных variables.tf
# Ничего не меняем
#
resource "vcd_vapp" "vm" {
  count      = var.VMCount
  name       = var.VMs[count.index].VmName
  depends_on = [vcd_network_routed.net]
}
resource "vcd_vapp_vm" "vm" {
  count           = var.VMCount
  vapp_name       = vcd_vapp.vm[count.index].name
  name            = var.VMs[count.index].VmName
  computer_name   = var.VMs[count.index].VmName
  storage_profile = var.VMs[count.index].StorageProfile
  catalog_name    = var.VMs[count.index].CatalogName
  template_name   = var.VMs[count.index].TemplateName
  memory          = var.VMs[count.index].ram
  cpus            = var.VMs[count.index].cpu
  cpu_cores       = var.VMs[count.index].cores
  power_on        = false
  network {
    type               = "org"
    name               = vcd_network_routed.net[0].name
    ip_allocation_mode = "DHCP"
    is_primary         = true
  }

customization {
    force                      = true
    initscript = "mkdir -p ${var.ssh_user_home}/.ssh; echo \"${local.ssh_key_pub}\" >> ${var.ssh_user_home}/.ssh/authorized_keys; chmod -R go-rwx ${var.ssh_user_home}/.ssh; restorecon -Rv ${var.ssh_user_home}/.ssh"
    # Other customization options to override the ones from template
  }

  depends_on = [vcd_vapp.vm]
}
