resource "proxmox_virtual_environment_download_file" "talos" {
  content_type            = "iso"
  datastore_id            = "local"
  node_name               = "pve"
  file_name               = "talos-nocloud-qemu-amd64.img"
  decompression_algorithm = "gz"
  overwrite               = false
  url                     = "https://factory.talos.dev/image/${talos_image_factory_schematic.this.id}/${local.talos_version}/nocloud-amd64.raw.gz"
}


resource "proxmox_virtual_environment_vm" "nodes" {
  count = 3

  name        = "talos-node-${count.index}"
  description = "Managed by Terraform"
  tags        = ["talos"]
  node_name   = "pve"
  on_boot     = true
  machine     = "q35"

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 4096
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.talos.id
    file_format  = "raw"
    interface    = "virtio0"
    size         = 16
  }

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    datastore_id = "local-lvm"
    dns {
      servers = [var.network.dns]
    }
    ip_config {
      ipv4 {
        address = "${cidrhost("192.168.200.0/24", 100 + count.index)}/16"
        gateway = var.network.gateway
      }
    }
  }
}

