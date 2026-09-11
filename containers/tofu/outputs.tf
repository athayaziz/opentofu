output "containers" {
  value = {
    for k, ct in proxmox_virtual_environment_container.debian_ct : k => {
      id   = ct.vm_id
      name = k
      ip = try(
        [
          for iface in data.proxmox_virtual_environment_container_interfaces.ct_net[k].interfaces :
          [for ip in iface.ip_addresses : ip.address if ip.type == "inet"]
          if iface.name == "eth0"
        ][0][0],
        "pending"
      )
    }
  }
  description = "Daftar LXC Container yang dibuat beserta ID dan IP"
}
