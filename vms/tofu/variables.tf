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

variable "template_id" {
  type        = number
  default     = 9001
  description = "ID VM Template"
}

variable "ssh_public_key" {
  type        = string
  description = "Public key SSH"
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
    "debian-13-xyops" = {
      vm_id     = 203
      username  = "xyops"
      password  = "12345"
      cores     = 2
      memory    = 4096
      disk_size = 20
    }
  }
}
