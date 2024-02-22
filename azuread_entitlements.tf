module "azuread_access_package_catalogs" {
  source   = "./modules/azuread/catalogs"
  for_each = local.azuread.azuread_access_package_catalogs

  settings = each.value
}

module "access_packages" {
  source   = "./modules/azuread/access_packages"
  for_each = local.azuread.azuread_access_packages

  settings             = each.value
  azuread_catalogs     = local.combined_objects_azuread_access_package_catalogs
  azuread_groups       = local.combined_objects_azuread_groups
  azuread_applications = local.combined_objects_azuread_applications
  client_config        = local.client_config
}

module "azuread_access_package_assignment_policies" {
  source   = "./modules/azuread/assignment_policies"
  for_each = local.azuread.azuread_access_package_assignment_policies

  settings        = each.value
  access_packages = local.combined_objects_azuread_access_packages
  client_config   = local.client_config
}

output "azuread_access_package_catalogs" {
  value = module.azuread_access_package_catalogs
}

output "azuread_access_packages" {
  value = module.access_packages
}

output "azuread_access_package_assignment_policies" {
  value = module.azuread_access_package_assignment_policies
}