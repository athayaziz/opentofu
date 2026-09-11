terraform {
  required_version = ">= 1.6.0"
  backend "local" {}
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.112.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.0"
    }
  }
}

provider "proxmox" {
  endpoint  = trimspace(var.proxmox_endpoint)
  api_token = trimspace(var.proxmox_api_token)
  insecure  = true
}
