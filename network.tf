#create private subnet
resource "azurerm_subnet" "tf-private-subnet" {
  name                 = "private-subnet"
  address_prefixes     = var.private_subnet_cidr
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.vnet.name
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

#create public subnet
resource "azurerm_subnet" "tf-pulic-subnet" {
  name                 = "public-subnet"
  address_prefixes     = var.public_subnet_cidr
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.vnet.name
}

#create postgres subnet
# resource "azurerm_subnet" "tf-postgres-subnet" {
#   name                 = "postgres-subnet"
#   address_prefixes     = var.postgres_subnet_cidr
#   resource_group_name  = module.resource_group.name
#   virtual_network_name = module.vnet.name
#   service_endpoints    = ["Microsoft.Storage"]

#   delegation {
#     name = "fs"
#     service_delegation {
#       name = "Microsoft.DBforPostgreSQL/flexibleServers"
#       actions = [
#         "Microsoft.Network/virtualNetworks/subnets/join/action",
#       ]
#     }
#   }
# }

#postgres flex private dns zone
resource "azurerm_private_dns_zone" "tf-postgres" {
  name                = "${terraform.workspace}.postgres.database.azure.com"
  resource_group_name = module.resource_group.name
  tags                = {
    "env" = terraform.workspace
  }
}

#postgres flex server dns zone vnet link 
resource "azurerm_private_dns_zone_virtual_network_link" "tf-postgres" {
  name                  = "${terraform.workspace}-postgres-pvt-dns-zone-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.tf-postgres.name
  virtual_network_id    = module.vnet.id
  resource_group_name   = module.resource_group.name
  tags                = {
    "env" = terraform.workspace
  }
}

#create public ip for load balancer
resource "azurerm_public_ip" "tf" {
  name                = "lb-public-ip"
  sku                 = "Standard"
  location            = var.location
  resource_group_name = module.resource_group.name
  allocation_method   = "Static"
  tags                = {
    "env" = terraform.workspace
  }
}

#create public ip for vmss
resource "azurerm_public_ip" "tf-vmss" {
  name                = "lb-vmss-public-ip"
  sku                 = "Standard"
  location            = var.location
  resource_group_name = module.resource_group.name
  allocation_method   = "Static"
  domain_name_label   = module.resource_group.name
  tags                = {
    "env" = terraform.workspace
  }
}

#create public network security group and rules
resource "azurerm_network_security_group" "tf-public-nsg" {
  name                = "public-nsg"
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = {
    "env" = terraform.workspace
  }

  security_rule {
    access                     = "Allow"
    description                = "AllowSSH"
    destination_address_prefix = "*"
    source_address_prefixes    = var.public_nsg_ssh_whitelist
    direction                  = "Inbound"
    name                       = "Allow SSH Inbound"
    priority                   = 110
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.public_nsg_ssh_port
  }
  security_rule {
    access                     = "Allow"
    description                = "Allow Http Webapp"
    destination_address_prefix = "*"
    source_address_prefix      = "*"
    direction                  = "Inbound"
    name                       = "AllowWebAppInBound"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.public_nsg_http_port
  }
  security_rule {
    access                     = "Deny"
    description                = "Deny all ports"
    destination_address_prefix = "*"
    destination_port_range     = "*"
    direction                  = "Inbound"
    name                       = "DenyAll"
    priority                   = 510
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
  }
}

#create private network security group and rules
resource "azurerm_network_security_group" "tf-private-nsg" {
  name                = "private-nsg"
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = {
    "env" = terraform.workspace
  }

  # security_rule {
  #   access                     = "Allow"
  #   description                = "Allow SSH"
  #   destination_address_prefix = "*"
  #   source_address_prefixes    = var.private_nsg_ssh_whitelist
  #   direction                  = "Inbound"
  #   name                       = "AllowSSHInBound"
  #   priority                   = 110
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = var.private_nsg_ssh_port
  # }

  # security_rule {
  #   access                     = "Allow"
  #   description                = "Allow Postgres"
  #   destination_address_prefix = "*"
  #   source_address_prefixes    = var.private_nsg_allows_source_postgres
  #   direction                  = "Inbound"
  #   name                       = "AllowPostgresInBound"
  #   priority                   = 120
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = var.private_nsg_postgres_port
  # }

  # security_rule {
  #   access                     = "Deny"
  #   description                = "Deny all ports"
  #   destination_address_prefix = "*"
  #   destination_port_range     = "*"
  #   direction                  = "Inbound"
  #   name                       = "DenyAll"
  #   priority                   = 500
  #   protocol                   = "*"
  #   source_address_prefix      = "*"
  #   source_port_range          = "*"
  # }
}

#create network interface
resource "azurerm_network_interface" "tf-nic" {
  count               = var.app_vm_count
  name                = "app-vm-${count.index}-nic"
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = {
    "env" = terraform.workspace
  }

  ip_configuration {
    name                          = "app-vm-${count.index}-nic"
    subnet_id                     = azurerm_subnet.tf-pulic-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#create network interface for postgres vm
# resource "azurerm_network_interface" "tf-nic-postgres" {
#   name                = "app-vm-postgres-nic"
#   location            = var.location
#   resource_group_name = module.resource_group.name
#   tags                = {
#     "env" = terraform.workspace
#   }

#   ip_configuration {
#     name                          = "app-vm-postgres-nic"
#     subnet_id                     = azurerm_subnet.tf-private-subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }


#connect security group to public subnet
resource "azurerm_subnet_network_security_group_association" "tf-public-nsg-association" {
  subnet_id                 = azurerm_subnet.tf-pulic-subnet.id
  network_security_group_id = azurerm_network_security_group.tf-public-nsg.id
}

#connect security group to priate subnet
# resource "azurerm_subnet_network_security_group_association" "tf-private-nsg-association" {
#   subnet_id                 = azurerm_subnet.tf-private-subnet.id
#   network_security_group_id = azurerm_network_security_group.tf-private-nsg.id
# }


#check network interface for public subnet
