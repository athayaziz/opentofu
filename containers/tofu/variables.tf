variable "proxmox_endpoint" {
  type        = string
}

variable "proxmox_api_token" {
  type        = string
  description = "API Proxmox Token"
  sensitive   = true
}

variable "proxmox_node" {
  type        = string
  default     = "pve"
}

variable "template_file_id" {
  type        = string
  default     = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
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
    "kubernetes" = {
      ct_id        = 106
      password     = "12345"
      cores        = 2
      memory       = 2048
      swap         = 512
      disk_size    = 8
      unprivileged = true
    }
  }
}
