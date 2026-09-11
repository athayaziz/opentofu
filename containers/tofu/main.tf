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
        address = "dhcp"
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
