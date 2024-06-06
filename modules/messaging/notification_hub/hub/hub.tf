resource "azurecaf_name" "hub" {
  name          = var.settings.name
  resource_type = "azurerm_notification_hub"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_notification_hub" "hub" {
  name                = azurecaf_name.hub.result
  namespace_name      = var.namespace_name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

  dynamic "apns_credential" {
    for_each = lookup(var.settings, "apns_credential", null) == null ? [] : [1]
    content {
      application_mode = var.settings.apns_credential.application_mode
      bundle_id        = var.settings.apns_credential.bundle_id
      key_id           = var.settings.apns_credential.key_id
      team_id          = var.settings.apns_credential.team_id
      token            = var.settings.apns_credential.token
    }
  }

  dynamic "gcm_credential" {
    for_each = lookup(var.settings, "gcm_credential", null) == null ? [] : [1]
    content {
      api_key = var.settings.gcm_credential.api_key
    }
  }
}