module "diagnostics" {
  source   = "../../../diagnostics"
  for_each = try(var.settings.diagnostic_profiles, {})

  resource_id       = azurerm_kusto_cluster.kusto.id
  resource_location = var.location
  diagnostics       = var.remote_objects.diagnostics
  profiles          = var.settings.diagnostic_profiles
}