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

# Data source untuk membaca IP aktual dari container
data "proxmox_virtual_environment_container_interfaces" "ct_net" {
  for_each     = proxmox_virtual_environment_container.debian_ct
  node_name    = var.proxmox_node
  container_id = each.value.vm_id
}

# Handoff otomatis ke Ansible (membuat file hosts.ini)
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tmpl", {
    containers = [
      for k, ct in proxmox_virtual_environment_container.debian_ct : {
        name = k
        ip = try(
          [
            for iface in data.proxmox_virtual_environment_container_interfaces.ct_net[k].interfaces :
            [for ip in iface.ip_addresses : ip.address if ip.type == "inet"]
            if iface.name == "eth0"
          ][0][0],
          "127.0.0.1"
        )
        user = "root"
      }
    ]
  })
  filename = "${path.module}/../ansible/inventory/hosts.ini"
}
