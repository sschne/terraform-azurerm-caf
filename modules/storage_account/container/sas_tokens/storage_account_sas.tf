data "azurerm_storage_account_blob_container_sas" "sas" {
  connection_string = var.primary_connection_string
  https_only        = true
  container_name    = var.storage_container_name
  start             = time_rotating.sas.id
  expiry            = timeadd(time_rotating.sas.id, format("%sh", var.settings.sas_policy.expire_in_days * 24))
  permissions {
    add    = try(var.settings.permissions.add, false)
    read   = try(var.settings.permissions.read, false)
    create = try(var.settings.permissions.create, false)
    delete = try(var.settings.permissions.delete, false)
    list   = try(var.settings.permissions.list, false)
    write  = try(var.settings.permissions.write, false)
  }
}
resource "time_rotating" "sas" {
  rotation_minutes = try(var.settings.sas_policy.rotation.mins, null)
  rotation_hours   = try(var.settings.sas_policy.rotation.hours, null)
  rotation_days    = try(var.settings.sas_policy.rotation.days, null)
  rotation_months  = try(var.settings.sas_policy.rotation.months, null)
  rotation_years   = try(var.settings.sas_policy.rotation.years, null)
}
resource "azurerm_key_vault_secret" "sas" {
  count        = try(var.settings.keyvault, {}) == {} ? 0 : 1
  name         = format("sas-url-%s-%s", var.storage_container_name, var.settings.name)
  value        = format("%s%s%s", var.primary_blob_endpoint, var.storage_container_name, data.azurerm_storage_account_blob_container_sas.sas.sas)
  key_vault_id = var.remote_objects.keyvaults[try(var.settings.lz_key, var.client_config.landingzone_key)][var.settings.keyvault.key].id
}

