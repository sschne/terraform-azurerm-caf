# Tested with :  AzureRM version 2.61.0
# Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container

resource "azurerm_storage_container" "stg" {
  name                  = var.settings.name
  storage_account_name  = var.storage_account_name
  container_access_type = try(var.settings.container_access_type, "private")
  metadata              = try(var.settings.metadata, null)
}

module "sas_token" {
  source = "./sas_tokens"
  for_each = {
    for key, value in try(var.settings.sas_token, {}) : key => value
    if var.primary_blob_endpoint != null
  }
  settings                  = each.value
  primary_connection_string = var.primary_connection_string
  storage_container_name    = azurerm_storage_container.stg.name
  client_config             = var.client_config
  remote_objects            = var.remote_objects
  primary_blob_endpoint     = var.primary_blob_endpoint
}

