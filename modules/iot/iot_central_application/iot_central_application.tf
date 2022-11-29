# Terraform azurerm resource: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iotcentral_application

data "azurecaf_name" "iotcentral_application" {
  name          = var.settings.name
  resource_type = "azurerm_iotcentral_application"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_iotcentral_application" "iotcentralapplication" {
  name                = data.azurecaf_name.iotcentral_application.result
  resource_group_name = var.resource_group_name
  location            = var.location
  sub_domain          = var.settings.sub_domain

  display_name = var.settings.display_name
  sku          = var.settings.sku
  template     = try(var.settings.template, null)

  tags = merge(local.tags, lookup(var.settings, "tags", {}))
}
