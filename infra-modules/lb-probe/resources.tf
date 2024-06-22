resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = var.lb_id
  name            = var.lb_probe_name
  protocol        = var.lb_probe_protocol != null ? var.lb_probe_protocol : null
  request_path    = var.lb_probe_request_path != null ? var.lb_probe_request_path : null
  port            = var.lb_probe_port
}

