location           = "eastus"
vnet_address_space = ["10.0.0.0/24"]
tags               = { "env" = terraform.workspace }

############### Network #################
private_subnet_cidr  = ["10.0.0.0/27"]
public_subnet_cidr   = ["10.0.0.32/27"]
postgres_subnet_cidr = ["10.0.0.64/28"]

public_nsg_ssh_whitelist = ["103.94.57.190","14.141.60.58","182.72.58.210"]
public_nsg_ssh_port = 22
public_nsg_http_port = 8080

private_nsg_ssh_port = 22
private_nsg_ssh_whitelist = ["10.0.0.32/27"]
private_nsg_allows_source_postgres =  ["10.0.0.32/27"] 
private_nsg_postgres_port = 5432

#####number of vms
app_vm_count = 3

vm_name = "app-vm"

#####vm size
machine_size = "Standard_B1s"
admin_user   = "azureuser"

########### OS Parameters ##############
os_disk_name         = "app-vm-disk"
storage_account_type = "Standard_LRS"
disk_size_gb         = 30

######### OS image parameters ###########
si_publisher = "Canonical"
si_offer     = "UbuntuServer"
si_sku       = "18.04-LTS"
si_version   = "latest"

########### Postgres Server #############
db_username = "pgadmin"
postgres_server_sku = "B_Standard_B1ms"
postgres_version = "12"
postgres_storage_mb = 32768
