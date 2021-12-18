# Create ECS
 resource "sbercloud_compute_instance" "ecs_01" {
  count             = var.VMCount
  name              = var.VMs[count.index].VmName
  image_name          = var.VMs[count.index].ImageName
  flavor_id         = var.VMs[count.index].FlavorName
  admin_pass        = var.VMs[count.index].AdminPass
  security_groups   = [var.VMs[count.index].SecGroups]
  availability_zone = var.VMs[count.index].AvailZone
 
  system_disk_type = "SAS"
  system_disk_size = 16    

network {
    uuid = sbercloud_vpc_subnet.subnet_01[0].id
 }

 depends_on = [sbercloud_vpc_subnet.subnet_01[0]]
}
