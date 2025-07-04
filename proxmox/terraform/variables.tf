# variable "nodes" {
#   description = "Node configuration for control planes and workers"
#   type = object({
#     controlplanes = map(object({
#       name = string
#       ip   = string
#       vm = object({
#         cores     = number
#         memory    = number
#         disk_size = number
#       })
#     }))
#     workers = map(object({
#       name = string
#       ip   = string
#       vm = object({
#         cores     = number
#         memory    = number
#         disk_size = number
#       })
#     }))
#   })
# }

variable "network" {
  description = "Network configuration"
  type = object({
    gateway = string
    dns     = string
    subnet  = string
  })
  default = {
    gateway = "192.168.8.1"
    dns     = "192.168.8.1"
    subnet  = "192.168.200.0/24"
  }
}
