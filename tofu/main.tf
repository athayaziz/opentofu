resource "proxmox_virtual_environment_vm" "debian_srv" {
  name            = var.vm_name
  node_name       = var.proxmox_node
  vm_id           = var.vm_id
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
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  disk {
    datastore_id = "local-lvm"
    size         = 20
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
      username = "debian"
      keys     = [trimspace(var.ssh_public_key)]
    }
  }
}

# Local untuk mengambil IP DHCP dari QEMU Guest Agent
# ipv4_addresses[1][0] = IP dari NIC pertama (index 0 = loopback)
locals {
  vm_ip = proxmox_virtual_environment_vm.debian_srv.ipv4_addresses[1][0]
}

# 5. Handoff otomatis ke Ansible (membuat file hosts.ini)
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tmpl", {
    vm_name = proxmox_virtual_environment_vm.debian_srv.name
    vm_ip   = local.vm_ip
  })
  filename = "${path.module}/../ansible/inventory/hosts.ini"
}
