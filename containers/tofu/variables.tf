variable "proxmox_endpoint" {
  type        = string
  description = "URL Proxmox Web"
}

variable "proxmox_api_token" {
  type        = string
  description = "API Proxmox Token"
  sensitive   = true
}

variable "proxmox_node" {
  type        = string
  default     = "pve"
  description = "Node Proxmox Name"
}

variable "template_file_id" {
  type        = string
  default     = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
  description = "Template file ID untuk LXC di storage Proxmox (misal: local:vztmpl/...)"
}

variable "ssh_public_key" {
  type        = string
  description = "Public key SSH yang akan di-inject ke container"
}

variable "containers" {
  type = map(object({
    ct_id        = number
    password     = string
    cores        = optional(number, 1)
    memory       = optional(number, 1024)
    swap         = optional(number, 512)
    disk_size    = optional(number, 8)
    unprivileged = optional(bool, true)
  }))
  default = {
    "ct-debian-01" = {
      ct_id        = 101
      password     = "12345"
      cores        = 1
      memory       = 1024
      swap         = 512
      disk_size    = 8
      unprivileged = true
    }
  }
  description = "Peta LXC Containers yang akan dibuat (bisa 1 atau lebih)"
}
