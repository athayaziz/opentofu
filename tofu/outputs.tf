output "vms" {
  value = {
    for k, vm in proxmox_virtual_environment_vm.debian_srv : k => {
      id       = vm.vm_id
      name     = vm.name
      ip       = vm.ipv4_addresses[1][0]
      username = var.vms[k].username
    }
  }
  description = "Daftar VM yang berhasil dibuat beserta IP dan username masing-masing"
}
