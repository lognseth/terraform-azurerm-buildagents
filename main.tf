resource "random_password" "adoagents_password" {
  length  = 30
  special = true
}

resource "azurerm_linux_virtual_machine_scale_set" "adoagents" {
  name                = var.vm_scale_set_name
  resource_group_name = var.resource_group_name
  location            = var.location

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  sku = var.sku

  instances = 0

  computer_name_prefix            = var.computer_name_prefix
  admin_username                  = var.admin_username
  admin_password                  = random_password.adoagents_password.result
  disable_password_authentication = var.disable_password_authentication

  custom_data = base64encode(var.cloud_init_config)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  overprovision = false

  upgrade_mode = "Manual"

  single_placement_group = false

  network_interface {
    name    = "NetworkProfile"
    primary = true
    ip_configuration {
      name                           = "internal"
      primary                        = true
      subnet_id                      = var.subnet_id
      application_security_group_ids = var.application_security_group_ids
    }
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags, instances]
  }
}

resource "azurerm_virtual_machine_scale_set_extension" "adoagents_health" {
  name                         = "HealthExtension"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.adoagents.id
  publisher                    = "Microsoft.ManagedServices"
  type                         = "ApplicationHealthLinux"
  type_handler_version         = "1.0"
  settings = jsonencode({
    protocol = "tcp"
    port     = 22
  })
}
