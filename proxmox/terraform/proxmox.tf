resource "proxmox_virtual_environment_download_file" "talos" {
  content_type            = "iso"
  datastore_id            = "local"
  node_name               = "pve"
  file_name               = "talos-${local.talos.platform}-${local.talos.arch}-qemu.img"
  decompression_algorithm = "gz"
  overwrite               = false
  url                     = "https://factory.talos.dev/image/${talos_image_factory_schematic.this.id}/${local.talos.version}/${local.talos.platform}-${local.talos.arch}.raw.gz"
}


resource "proxmox_virtual_environment_vm" "control" {
  count = 1

  name        = "talos-control-${count.index + 1}"
  description = "Managed by Terraform"
  tags        = ["talos"]
  node_name   = "pve"
  on_boot     = true
  machine     = "q35"

  cpu {
    cores = 4
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
        address = "${cidrhost(var.network.subnet, 100 + count.index + 1)}/16"
        gateway = var.network.gateway
      }
    }
  }
}

resource "proxmox_virtual_environment_vm" "worker" {
  count = 2

  name        = "talos-worker-${count.index + 1}"
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
        address = "${cidrhost(var.network.subnet, 200 + count.index + 1)}/16"
        gateway = var.network.gateway
      }
    }
  }
}
