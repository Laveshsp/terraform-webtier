resource "random_password" "vm_pwd" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                            = var.vm_name
  resource_group_name             = var.vm_rg_name
  location                        = var.vm_location
  size                            = var.vm_size
  disable_password_authentication = false
  admin_username                  = var.vm_uname
  admin_password                  = random_password.vm_pwd.result

  network_interface_ids = var.vm_nic_ids
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  custom_data = var.vm_custom_data != null ? base64encode(var.vm_custom_data) : null
  tags        = var.vm_tags
}