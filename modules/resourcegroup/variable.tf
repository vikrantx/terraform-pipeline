variable "rg_names" {
  type = map(any)
  default = {
    stage = "rg-stage"
    prod  = "rg-prod"
  }
  description = "resource group name map for different environment"
}

variable "location" {
  type = string
  description = "resource group location"
}

variable "tags" {
  type = map
  description = "tags for resource"
  default = { env = "stage"}
}