output "containers" {
  value = {
    for k, ct in proxmox_virtual_environment_container.debian_ct : k => {
      id   = ct.vm_id
      name = k
    }
  }
  description = "Daftar LXC Container yang berhasil dibuat"
}
