######################Virtual Machine variables ########################
variable "vm_name" {
    type = string
    description = "instance name" 
}

variable "location" {
    type = string
    description = "instance location" 
}

variable "resource_group_name" {
    type = string
    description = "instance location resource group" 
}

variable "machine_size" {
    type = string
    description = "instance size" 
}

variable "admin_user" {
    type = string
    description = "admin user name" 
}

variable "admin_password" {
    type = string
    description = "admin user password" 
}

variable "availability_set_id" {
    type = string
    description = "availability_set_id" 
}

variable "nic_ids" {
    type = list(string)
    description = "NIC id" 
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