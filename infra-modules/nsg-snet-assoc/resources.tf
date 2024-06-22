resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = var.assoc_snet_id
  network_security_group_id = var.assoc_nsg_id
}