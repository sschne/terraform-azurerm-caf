resource "azurerm_federated_identity_credential" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  audience            = try(var.settings.audience, ["api://AzureADTokenExchange"])

  issuer = can(var.settings.issuer_id) ? var.settings.issuer_id : (
    var.remote_objects.aks_clusters[try(var.settings.aks_cluster.lz_key, var.client_config.landingzone_key)][try(var.settings.aks_cluster.key, var.settings.aks_cluster_key)].oidc_issuer_url
  )

  parent_id = can(var.settings.managed_identity_id) ? var.settings.managed_identity_id : var.remote_objects.managed_identities[try(var.settings.managed_identity.lz_key, var.client_config.landingzone_key)][try(var.settings.managed_identity.key, var.settings.managed_identity_key)].id
  subject   = var.settings.subject
}

resource "time_sleep" "propagate_to_azuread" {
  depends_on = [azurerm_federated_identity_credential.this]

  create_duration = "30s"
}
