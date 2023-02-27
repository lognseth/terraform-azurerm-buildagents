variable "vm_scale_set_name" {
  type        = string
  description = "The name of the VMSS to be provisioned"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group in which the VMSS should be provisioned"
}

variable "location" {
  type        = string
  description = "The region in which the VMSS is provisioned"
}

variable "subnet_id" {
  type        = string
  description = "The subnet of the virtual network in which the VMSS should be deployed"
}

variable "cloud_init_config" {
  type        = string
  description = "A cloud init config file for startup configuration"
}

variable "disable_password_authentication" {
  type        = bool
  description = "Should Password Authentication be disabled on this VMSS?"
  default     = false
}

variable "admin_username" {
  type        = string
  description = "The username of the administrator on each VMSS instance"
  default     = "azureuser"
}

variable "computer_name_prefix" {
  type        = string
  description = "A prefix which should be used by the Virtual Machines in the Scale Set"
  default     = "agents"
}

variable "sku" {
  type        = string
  description = "The Virtual Machine SKU for the Scale Set"
  default     = "Standard_B2s"
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "Parameters for the source image of the Virtual Machine"
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

variable "application_security_group_ids" {
  type        = list(string)
  description = "Application Security Groups (ASGs) to associate with the Virtual Machine Scale Set"
  default     = []
}
