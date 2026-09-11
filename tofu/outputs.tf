output "vm_name" {
  value = proxmox_virtual_environment_vm.debian_srv.name
}

output "vm_ip_address" {
  value       = local.vm_ip
  description = "IP yang didapat VM dari DHCP"
}
