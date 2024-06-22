locals {
  resource_group_webtier = {
    resource_group_name = "rg-${local.project}-${local.environment}-webtier"
  }
}

module "rg-webtier" {
  source                  = "../../../infra-modules/rg"
  resource_group_name     = local.resource_group_webtier.resource_group_name
  resource_group_location = local.location
  resource_group_tag      = local.tags
}