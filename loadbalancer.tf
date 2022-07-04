resource "azurerm_lb" "main" {
  name                = "lb-wt-app"
  location            = var.location
  resource_group_name = module.resource_group.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "lb-public-ip-config"
    public_ip_address_id = azurerm_public_ip.tf.id
  }
   tags                = {
    "env" = terraform.workspace
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  name            = "lb-wt-app-bepool"
  loadbalancer_id = azurerm_lb.main.id
}

resource "azurerm_lb_probe" "main" {
  name            = "lb-wt-app-health-probe"
  loadbalancer_id = azurerm_lb.main.id
  port            = 8080
}

resource "azurerm_lb_rule" "main" {
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "lb-public-ip-config"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
  probe_id                       = azurerm_lb_probe.main.id
}

# resource "azurerm_network_interface_backend_address_pool_association" "tf" {
#     count = 3
#     network_interface_id = "${element(azurerm_network_interface.tf-nic.*.id, count.index)}"
#     ip_configuration_name = "app-vm-${count.index}-nic"
#     backend_address_pool_id = azurerm_lb_backend_address_pool.tf.id

# }

#load balancer NAT rule
resource "azurerm_lb_nat_rule" "main" {
  count                          = var.app_vm_count
  resource_group_name            = module.resource_group.name
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "lb-nat-ssh-${count.index}"
  protocol                       = "Tcp"
  frontend_port                  = "20${count.index}"
  backend_port                   = 22
  frontend_ip_configuration_name = "lb-public-ip-config"
}

#nat rule asssociation
resource "azurerm_network_interface_nat_rule_association" "main" {
  count                 = var.app_vm_count
  network_interface_id  = azurerm_network_interface.tf-nic[count.index].id
  ip_configuration_name = "app-vm-${count.index}-nic"
  nat_rule_id           = azurerm_lb_nat_rule.main[count.index].id
}

#enable this
resource "azurerm_lb_backend_address_pool_address" "main" {
  count                   = var.app_vm_count
  name                    = "lb-bepool-address-${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
  virtual_network_id      = module.vnet.id
  ip_address              = azurerm_network_interface.tf-nic[count.index].private_ip_address
}