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

variable "vm_id" {
  type        = number
  default     = 202
  description = "VM ID baru yang akan dibuat"
}

variable "vm_name" {
  type        = string
  default     = "srv-debian-01"
}

variable "ssh_public_key" {
  type        = string
  description = "Public key SSH yang akan di-inject ke user debian"
}

variable "vm_password" {
  type        = string
  default     = "12345"
  description = "Password user debian untuk login Console Proxmox"
  sensitive   = true
}
