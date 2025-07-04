terraform {
  required_version = ">= 1.9"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5"
    }
    dns = {
      source  = "hashicorp/dns"
      version = ">= 3.3"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.7"
    }
    talos = {
      source  = "siderolabs/talos"
      version = ">= 0.7"
    }
  }
}

provider "proxmox" {
  insecure = true

  ssh {
    agent = true
  }
}

provider "talos" {}
