locals {
  snet_webtier = {
    snet_name = "snet-${local.project}-${local.environment}-webtier"
    snet_cidr = ["10.10.0.0/26"]
  }
}

module "snet-webtier" {
  source         = "../../../infra-modules/subnet"
  snet_name      = local.snet_webtier.snet_name
  snet_rg_name   = local.resource_group_webtier.resource_group_name
  snet_vnet_name = local.vnet_webtier.vnet_name
  snet_cidr      = local.snet_webtier.snet_cidr
  depends_on     = [module.vnet-webtier]
}