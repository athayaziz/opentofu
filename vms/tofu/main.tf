resource "proxmox_virtual_environment_vm" "debian_srv" {
  for_each        = var.vms

  name            = each.key
  node_name       = var.proxmox_node
  vm_id           = each.value.vm_id
  stop_on_destroy = true

  # 1. Clone dari template Debian 12
  clone {
    vm_id = var.template_id
    full  = true
  }

  # 2. QEMU Guest Agent (Wajib aktif untuk membaca status boot & IP)
  agent {
    enabled = true
    timeout = "15m"
  }

  # 3. Hardware Specs
  cpu {
    cores = each.value.cores
    type  = "host"
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = "local-lvm"
    size         = each.value.disk_size
    interface    = "scsi0"
  }

  # 4. Cloud-Init Injection (DHCP)
  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      username = each.value.username
      password = each.value.password
      keys     = [trimspace(var.ssh_public_key)]
    }
  }
}

# 5. Handoff otomatis ke Ansible (membuat file hosts.ini)
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tmpl", {
    vms = [
      for k, vm in proxmox_virtual_environment_vm.debian_srv : {
        name = vm.name
        ip   = vm.ipv4_addresses[1][0]
        user = var.vms[k].username
      }
    ]
  })
  filename = "${path.module}/../ansible/inventory/hosts.ini"
}
