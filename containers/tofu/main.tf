resource "proxmox_virtual_environment_container" "debian_ct" {
  for_each     = var.containers

  node_name    = var.proxmox_node
  vm_id        = each.value.ct_id
  description  = "Managed by OpenTofu GitOps"
  unprivileged = each.value.unprivileged
  started      = true

  features {
    nesting = true
  }

  initialization {
    hostname = each.key
    ip_config {
      ipv4 {
        address = each.value.ip_address
        gateway = each.value.ip_address != "dhcp" ? each.value.gateway : null
      }
    }
    user_account {
      password = each.value.password
      keys     = [trimspace(var.ssh_public_key)]
    }
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  cpu {
    cores        = each.value.cores
    architecture = "amd64"
  }

  memory {
    dedicated = each.value.memory
    swap      = each.value.swap
  }

  disk {
    datastore_id = "local-lvm"
    size         = each.value.disk_size
  }

  operating_system {
    template_file_id = var.template_file_id
    type             = "debian"
  }
}

# Handoff otomatis ke Ansible (membuat file hosts.ini)
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tmpl", {
    containers = [
      for k, ct in var.containers : {
        name = k
        ip   = ct.ip_address != "dhcp" ? split("/", ct.ip_address)[0] : ct.ip_address
        user = "root"
      }
    ]
  })
  filename = "${path.module}/../ansible/inventory/hosts.ini"
}
