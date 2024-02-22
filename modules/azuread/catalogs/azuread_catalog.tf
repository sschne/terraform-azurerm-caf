
resource "azuread_access_package_catalog" "catalog" {
  display_name       = var.settings.display_name
  description        = var.settings.description
  externally_visible = try(var.settings.externally_visible, false)
  published          = try(var.settings.published, true)
}