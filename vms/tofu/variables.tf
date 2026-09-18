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
    "semaphore-ui" = {
      vm_id     = 203
      username  = "debian"
      password  = "12345"
      cores     = 1
      memory    = 1024
      disk_size = 15
    }
  }
  description = "Peta VM yang akan dibuat. Bisa 1 VM atau lebih, masing-masing dengan user & password berbeda."
}
