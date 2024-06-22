locals {

  nic_vm_webtier = {
    nic_name         = "nic-${local.project}-${local.environment}-webtier"
    nic_ip_conf_name = "nic-ip-conf-${local.project}-${local.environment}-webtier"
  }

  #   pip_vm_webtier= {
  #     pip_name = "pip-${local.project}-${local.environment}-webtier"
  #   }

  nsg_snet_webtier = {
    nsg_name = "nsg-vm-${local.project}-${local.environment}-webtier"
    nsg_rules = [
      {
        name                       = "allow-ib-http"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "allow-ib-ssh"
        priority                   = 1050
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "deny-ib-all"
        priority                   = 4096
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "allow-ob-http"
        priority                   = 1000
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "allow-ob-https"
        priority                   = 1050
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "deny-ob-all"
        priority                   = 4096
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }

  vm_webtier = {
    vm_name         = "vm-${local.project}-${local.environment}-webtier"
    vm_size         = "Standard_B2ms"
    vm_uname        = var.vm_uname
    vm_os_publisher = "canonical"
    vm_os_offer     = "0001-com-ubuntu-server-jammy"
    vm_os_sku       = "22_04-lts-gen2"
    vm_os_version   = "latest"
    vm_custom_data  = file("conf-files/custom-data-init.txt")
  }

}

module "vm-webtier" {
  source          = "../../../infra-modules/vm"
  vm_name         = local.vm_webtier.vm_name
  vm_rg_name      = local.resource_group_webtier.resource_group_name
  vm_location     = local.location
  vm_size         = local.vm_webtier.vm_size
  vm_uname        = local.vm_webtier.vm_uname
  vm_nic_ids      = [module.nic-vm-webtier.nic_id]
  vm_os_publisher = local.vm_webtier.vm_os_publisher
  vm_os_offer     = local.vm_webtier.vm_os_offer
  vm_os_sku       = local.vm_webtier.vm_os_sku
  vm_os_version   = local.vm_webtier.vm_os_version
  vm_custom_data  = local.vm_webtier.vm_custom_data
  vm_tags         = local.tags
  depends_on      = [module.rg-webtier, module.nic-vm-webtier]
}

module "nsg-vm-webtier" {
  source       = "../../../infra-modules/nsg"
  nsg_name     = local.nsg_snet_webtier.nsg_name
  nsg_rg_name  = local.resource_group_webtier.resource_group_name
  nsg_location = local.location
  nsg_rules    = local.nsg_snet_webtier.nsg_rules
  nsg_tags     = local.tags
  depends_on   = [module.rg-webtier]
}

module "nsg-snet-assoc-webtier" {
  source        = "../../../infra-modules/nsg-snet-assoc"
  assoc_snet_id = module.snet-webtier.snet_id
  assoc_nsg_id  = module.nsg-vm-webtier.nsg_id
}

# module "pip-vm-webtier" {
#     source = "../../../infra-modules/publicip"
#     pip_name = local.pip_vm_webtier.pip_name
#     pip_rg_name = local.resource_group_webtier.resource_group_name
#     pip_location = local.location
#     pip_tags = local.tags 
#     depends_on = [ module.rg-webtier ]
# }

module "nic-vm-webtier" {
  source           = "../../../infra-modules/nic"
  nic_name         = local.nic_vm_webtier.nic_name
  nic_rg_name      = local.resource_group_webtier.resource_group_name
  nic_location     = local.location
  nic_snet_id      = module.snet-webtier.snet_id
  nic_ip_conf_name = local.nic_vm_webtier.nic_ip_conf_name
  nic_pip_id       = null
  nic_tags         = local.tags
  depends_on       = [module.snet-webtier]
}