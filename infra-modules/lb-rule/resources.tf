resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = var.lb_id
  name                           = var.lb_rule_name
  protocol                       = var.lb_rule_protocol
  frontend_port                  = var.lb_rule_frontend_port
  backend_port                   = var.lb_rule_backend_port
  frontend_ip_configuration_name = var.lb_rule_ip_conf_name
  backend_address_pool_ids       = var.lb_rule_backend_address_pool_ids
  probe_id                       = var.lb_rule_probe_id
}