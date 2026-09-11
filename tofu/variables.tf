variable "proxmox_endpoint" {
  type        = string
  description = "URL Proxmox Web GUI, contoh: https://192.168.1.100:8006/"
}

variable "proxmox_api_token" {
  type        = string
  description = "Token API Proxmox (Format: USER@REALM!TOKENID=UUID)"
  sensitive   = true
}

variable "proxmox_node" {
  type        = string
  default     = "pve"
  description = "Nama node Proxmox Anda"
}

variable "template_id" {
  type        = number
  default     = 9001
  description = "ID VM Template Debian 12 yang dibuat sebelumnya"
}

variable "ssh_public_key" {
  type        = string
  description = "Public key SSH yang akan di-inject ke user debian"
}

variable "vms" {
  type = map(object({
    vm_id     = number
    username  = string
    password  = string
    cores     = optional(number, 1)
    memory    = optional(number, 2048)
    disk_size = optional(number, 15)
  }))
  default = {
    "srv-debian-01" = {
      vm_id     = 202
      username  = "debian"
      password  = "12345"
      cores     = 1
      memory    = 2048
      disk_size = 15
    }
  }
  description = "Peta VM yang akan dibuat. Bisa 1 VM atau lebih, masing-masing dengan user & password berbeda."
}
