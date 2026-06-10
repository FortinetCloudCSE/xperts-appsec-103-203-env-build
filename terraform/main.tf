locals {

  username_prefix = var.username_prefix
  user_count      = tonumber(var.user_count)
  user_start      = tonumber(var.user_start)

  rg_suffix             = var.rg_suffix
  location              = var.location
  vm_username           = var.vm_username
  password              = var.password
  fortiflexvm_config_id = var.fortiflexvm_config_id

  environments = {
    for i in range(local.user_start, local.user_start + local.user_count) :
    format("%s%02s", local.username_prefix, i) => { username = format("%s%02s", local.username_prefix, i) }
  }
}

module "module_appsec-102-203" {

  for_each = local.environments

  source = "./modules/azure"

  location    = local.location
  rg_suffix   = local.rg_suffix
  rg_prefix   = each.value.username
  vm_username = local.vm_username
  password    = local.password

  fortiflex_access_username = var.fortiflex_access_username
  fortiflex_access_password = var.fortiflex_access_password

  fortiflexvm_config_id = var.fortiflexvm_config_id

  fortiflex_serial_numbers = var.fortiflex_serial_numbers[each.key]

}

output "fad_vm_tokens" {
  value = {
    value = module.module_appsec-102-203[*]
  }
}

output "environments" {
  value = {
    value = local.environments
  }
}

output "bastion_shareable_link" {
  value = [for key, rg in module.module_appsec-102-203 : replace(format("%s, %s?protocol=rdp", key, rg.bastion_shareable_links.value[0].bsl), "api/shareable-url", "#/url-metadata")]
}
