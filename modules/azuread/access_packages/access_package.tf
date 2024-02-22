resource "azuread_access_package" "access_package" {
  catalog_id   = can(var.settings.catalog.id) ? var.settings.catalog.id : var.azuread_catalogs[try(var.client_config.landingzone_key, var.settings.catalog.lz_key)][var.settings.catalog.key].id
  display_name = var.settings.display_name
  description  = var.settings.description
  hidden       = try(var.settings.hidden, false)
}

resource "azuread_access_package_resource_catalog_association" "this" {
  catalog_id             = can(var.settings.catalog.id) ? var.settings.catalog.id : var.azuread_catalogs[try(var.client_config.landingzone_key, var.settings.catalog.lz_key)][var.settings.catalog.key].id
  resource_origin_id     = can(var.settings.resource_origin.id) ? var.settings.resource_origin.id : try(var.settings.resource_origin_system, "AadGroup") == "AadGroup" ? var.azuread_groups[var.client_config.landingzone_key][var.settings.resource_origin.key].object_id : var.azuread_applications[var.client_config.landingzone_key][var.settings.resource_origin.key].id
  resource_origin_system = var.settings.resource_origin_system
}

resource "azuread_access_package_resource_package_association" "this" {
  access_package_id               = azuread_access_package.access_package.id
  catalog_resource_association_id = azuread_access_package_resource_catalog_association.this.id
}