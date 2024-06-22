resource "azurerm_lb" "load_balancer" {
  name                = var.lb_name
  location            = var.lb_location
  resource_group_name = var.lb_rg_name

  frontend_ip_configuration {
    name                 = var.lb_frontend_ip_conf_name
    public_ip_address_id = var.lb_pip_id != null ? var.lb_pip_id : null
    subnet_id            = var.lb_snet_id != null ? var.lb_snet_id : null
  }
  tags = var.lb_tags
}