module "nics" {
  source   = "../../diagnostics"
  for_each = try(var.settings.networking_interfaces, toset([]))

  resource_id       = local.network_interfaces[each.key].id
  resource_location = local.network_interfaces[each.key].location
  diagnostics       = var.diagnostics
  profiles          = try(each.value.diagnostic_profiles, {})
}
