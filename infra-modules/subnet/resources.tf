resource "azurerm_subnet" "subnet" {
  name                 = var.snet_name
  resource_group_name  = var.snet_rg_name
  virtual_network_name = var.snet_vnet_name
  address_prefixes     = var.snet_cidr
}