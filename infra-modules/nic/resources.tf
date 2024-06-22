resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.nic_location
  resource_group_name = var.nic_rg_name

  ip_configuration {
    name                          = var.nic_ip_conf_name
    subnet_id                     = var.nic_snet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.nic_pip_id != null ? var.nic_pip_id : null
  }
  tags = var.nic_tags
}