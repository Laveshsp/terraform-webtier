resource "azurerm_lb_backend_address_pool" "lb_backend_address_pool" {
  name            = var.lb_backend_address_pool_name
  loadbalancer_id = var.lb_id
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_nic_backend_pool_assoc" {
  network_interface_id    = var.lb_nic_id
  ip_configuration_name   = var.lb_backend_ip_conf_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
}