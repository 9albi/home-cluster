locals {
  talos = {
    platform = "nocloud"
    arch     = "amd64"
    version  = "v1.10.5"
  }
}

data "talos_image_factory_extensions_versions" "this" {
  # get the latest talos version
  talos_version = local.talos.version
  filters = {
    names = [
      "siderolabs/qemu-guest-agent",
    ]
  }
}

resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = data.talos_image_factory_extensions_versions.this.extensions_info.*.name
        }
      }
    }
  )
}

