locals {

  pip_alb_webtier = {
    pip_name = "pip-alb-${local.project}-${local.environment}-webtier"
  }

  lb_webtier = {
    lb_name                  = "alb-${local.project}-${local.environment}-webtier"
    lb_frontend_ip_conf_name = "alb-frontend-ip-${local.project}-${local.environment}-webtier"
  }

  lb_nic_backend_assoc = {
    lb_backend_address_pool_name = "backendpool-${local.project}-${local.environment}-webtier"
  }

  lb_probe = {
    lb_probe_name         = "probe-http-${local.project}-${local.environment}-webtier"
    lb_probe_protocol     = "Http"
    lb_probe_request_path = "/"
    lb_probe_port         = 80
  }

  lb_rule = {
    lb_rule_name          = "rule-http-${local.project}-${local.environment}-webtier"
    lb_rule_protocol      = "Tcp"
    lb_rule_frontend_port = 80
    lb_rule_backend_port  = 80
  }
}

module "rule-alb-webtier" {
  source                           = "../../../infra-modules/lb-rule"
  lb_rule_name                     = local.lb_rule.lb_rule_name
  lb_id                            = module.alb-webtier.lb_id
  lb_rule_protocol                 = local.lb_rule.lb_rule_protocol
  lb_rule_frontend_port            = local.lb_rule.lb_rule_frontend_port
  lb_rule_backend_port             = local.lb_rule.lb_rule_backend_port
  lb_rule_ip_conf_name             = local.lb_webtier.lb_frontend_ip_conf_name
  lb_rule_backend_address_pool_ids = [module.backend-alb-webtier.lb_backend_pool_id]
  lb_rule_probe_id                 = module.probe-alb-webtier.lb_probe_id

  depends_on = [module.alb-webtier, module.probe-alb-webtier, module.backend-alb-webtier]
}

module "probe-alb-webtier" {
  source                = "../../../infra-modules/lb-probe"
  lb_probe_name         = local.lb_probe.lb_probe_name
  lb_id                 = module.alb-webtier.lb_id
  lb_probe_protocol     = local.lb_probe.lb_probe_protocol
  lb_probe_request_path = local.lb_probe.lb_probe_request_path
  lb_probe_port         = local.lb_probe.lb_probe_port
  depends_on            = [module.rg-webtier, module.alb-webtier]
}

module "backend-alb-webtier" {
  source                       = "../../../infra-modules/lb-backend-pool"
  lb_backend_address_pool_name = local.lb_nic_backend_assoc.lb_backend_address_pool_name
  lb_id                        = module.alb-webtier.lb_id
  lb_nic_id                    = module.nic-vm-webtier.nic_id
  lb_backend_ip_conf_name      = local.nic_vm_webtier.nic_ip_conf_name
  depends_on                   = [module.rg-webtier, module.nic-vm-webtier, module.alb-webtier, module.vm-webtier]
}

module "alb-webtier" {
  source                   = "../../../infra-modules/lb"
  lb_name                  = local.lb_webtier.lb_name
  lb_rg_name               = local.resource_group_webtier.resource_group_name
  lb_location              = local.location
  lb_tags                  = local.tags
  lb_frontend_ip_conf_name = local.lb_webtier.lb_frontend_ip_conf_name
  lb_pip_id                = module.pip-alb-webtier.pip_id
  lb_snet_id               = null
  depends_on               = [module.rg-webtier, module.pip-alb-webtier]
}

module "pip-alb-webtier" {
  source       = "../../../infra-modules/publicip"
  pip_name     = local.pip_alb_webtier.pip_name
  pip_rg_name  = local.resource_group_webtier.resource_group_name
  pip_location = local.location
  pip_tags     = local.tags
  depends_on   = [module.rg-webtier]
}
