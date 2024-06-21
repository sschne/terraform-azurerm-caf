module "cdn_frontdoor_profiles" {
  source   = "./modules/networking/cdn_frontdoor/cdn_frontdoor_profiles"
  for_each = try(local.networking.cdn_frontdoor_profiles, {})

  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  global_settings     = local.global_settings
  client_config       = local.client_config
  settings            = each.value
  location            = can(each.value.resource_group.location) || can(each.value.resource_group_location) ? try(each.value.resource_group.location, each.value.resource_group_location) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name

  combined_objects = {
    api_management      = local.combined_objects_api_management
    load_balancers      = local.combined_objects_lb
    public_ip_addresses = local.combined_objects_public_ip_addresses
  }
}

output "cdn_frontdoor_profiles" {
  value = module.cdn_frontdoor_profiles
}