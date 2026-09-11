output "containers" {
  value = {
    for k, ct in var.containers : k => {
      id   = ct.ct_id
      name = k
      ip   = ct.ip_address != "dhcp" ? split("/", ct.ip_address)[0] : ct.ip_address
    }
  }
  description = "Daftar LXC Container yang dibuat beserta ID dan IP"
}
