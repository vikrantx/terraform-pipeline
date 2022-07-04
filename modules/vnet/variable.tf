variable "resource_group_name" {
  type = string
  default = "resource group name"
}

variable "vnet_name" {
  type = string
  default = "vnet"
  description = "virtual network name"
}

variable "location" {
  type = string
  description = "resource location"
}

variable "vnet_address_space" {
  type = list(string)
  description = "virtual network address space"
}
