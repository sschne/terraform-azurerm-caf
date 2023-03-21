locals {
  value = try(var.config.urlencode, false) ? urlencode(var.value) : var.value
}

resource "azurerm_key_vault_secret" "secret" {
  name         = var.name
  value        = can(var.config.value_template) ? format(var.config.value_template, local.value) : local.value
  key_vault_id = var.keyvault_id

  lifecycle {
    ignore_changes = [
      key_vault_id
    ]
  }
}
