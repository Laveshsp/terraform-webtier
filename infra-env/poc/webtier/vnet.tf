locals {
  vnet_webtier = {
    vnet_name = "vnet-${local.project}-${local.environment}-webtier"
    vnet_cidr = ["10.10.0.0/22"]
  }
}

module "vnet-webtier" {
  source        = "../../../infra-modules/vnet"
  vnet_name     = local.vnet_webtier.vnet_name
  vnet_rg_name  = local.resource_group_webtier.resource_group_name
  vnet_location = local.location
  vnet_cidr     = local.vnet_webtier.vnet_cidr
  vnet_tags     = local.tags
  depends_on    = [module.rg-webtier]
}