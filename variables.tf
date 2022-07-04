variable "location" {
  type = string
  default = "eastus1"
  description = "resource group location"
}

#################### Network #########################
variable "vnet_address_space" {
  type = list(string)
  description = "virtual network address space"
}

variable "private_subnet_cidr" {
  type = list(string)
  description = "virtual network address space"
}

variable "public_subnet_cidr" {
  type = list(string)
  description = "virtual network address space"
}

variable "postgres_subnet_cidr" {
  type = list(string)
  description = "virtual network address space"
}

#########Public NSG Security Rule Allow SSH#########
variable "public_nsg_ssh_whitelist" {
  type = list(string)
  description = "Allow ssh access to whitelisted addresses"
}

variable "public_nsg_ssh_port" {
  type = number
  description = "ssh port"
}

variable "public_nsg_http_port" {
  type = number
  description = "ssh port"
}

variable "private_nsg_ssh_port" {
  type = number
  description = "Allow ssh access to whitelisted addresses"
}

variable "private_nsg_ssh_whitelist" {
  type = list(string)
  description = "Allow ssh access to whitelisted addresses"
}

variable "private_nsg_allows_source_postgres" {
  type = list(string)
  description = "Allow ssh access to postgres"
}

variable "private_nsg_postgres_port" {
  type = number
  description = "postgres port"
}

########################VM Module Variables###########################
######################Virtual Machine variables ########################
variable "vm_name" {
    type = string
    description = "instance name" 
}

variable "machine_size" {
    type = string
    description = "instance size" 
}

variable "admin_user" {
    type = string
    description = "admin user name" 
}

#########################  os_disk variables ##########################
variable "os_disk_name" {
    type = string
    description = "os_disk_name" 
}

variable "caching" {
    type = string
    default = "ReadWrite"
    description = "caching" 
}

variable "storage_account_type" {
    type = string
    description = "storage_account_type" 
}

variable "disk_size_gb" {
    type = number
    default = 30
    description = "disk_size_gb" 
}

################# source_image_reference variables ######################
variable "si_publisher" {
    type = string
    description = "publisher" 
}

variable "si_offer" {
    type = string
    description = "offer" 
}

variable "si_sku" {
    type = string
    description = "sku" 
}

variable "si_version" {
    type = string
    description = "version" 
}
#########################################################################

variable "app_vm_count"{
type = number
description = "vm count"
}

################### Postgres Server ########################
variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "postgres_server_sku" {
  type = string
  description = "postgres flex server sku"
}

variable "postgres_version" {
  type = string
  description = "postgres version"
}

variable "postgres_storage_mb" {
  type = number
  description = "storage size in mb"
}