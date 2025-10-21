locals {

  username_prefix = var.username_prefix
  user_count      = tonumber(var.user_count)
  user_start      = tonumber(var.user_start)

  rg-suffix   = var.rg-suffix
  location    = var.location
  vm_username = var.vm_username
  password    = var.password

  environments = {
    for i in range(local.user_start, local.user_start + local.user_count) :
    format("%s%02s", local.username_prefix, i) => { username = format("%s%02s", local.username_prefix, i) }
  }
}

module "module_appsec-102-203" {

  for_each = local.environments

  source = "./modules/azure"

  location    = local.location
  rg-suffix   = local.rg-suffix
  rg-prefix   = each.value.username
  vm_username = local.vm_username
  password    = local.password

  fortiflexvm_token_adc_1 = fortiflexvm_entitlements_vm_token.entitlements_vm_token_vm_adc_1[each.value.username].token
  fortiflexvm_token_adc_2 = fortiflexvm_entitlements_vm_token.entitlements_vm_token_vm_adc_2[each.value.username].token

}

data "fortiflexvm_entitlements_list" "entitlements_list" {

  for_each = var.fortiflex_serial_numbers

  account_id            = var.fortiflexvm_account_id
  program_serial_number = var.fortiflexvm_program_serial_number

  serial_number = each.value.fortiflex_serial
}

resource "fortiflexvm_entitlements_vm" "entitlements_vm_adc_1" {
  for_each = local.environments

  config_id     = data.fortiflexvm_entitlements_list.entitlements_list["${each.value.username}_adc_1"].entitlements[0].config_id
  serial_number = data.fortiflexvm_entitlements_list.entitlements_list["${each.value.username}_adc_1"].entitlements[0].serial_number
  status        = "ACTIVE"
}

resource "fortiflexvm_entitlements_vm_token" "entitlements_vm_token_vm_adc_1" {
  for_each = local.environments

  config_id        = data.fortiflexvm_entitlements_list.entitlements_list["${each.value.username}_adc_1"].entitlements[0].config_id
  serial_number    = data.fortiflexvm_entitlements_list.entitlements_list["${each.value.username}_adc_1"].entitlements[0].serial_number
  regenerate_token = data.fortiflexvm_entitlements_list.entitlements_list["${each.value.username}_adc_1"].entitlements[0].token_status == "USED" && data.fortiflexvm_entitlements_list.entitlements_list[each.key].entitlements[0].status == "ACTIVE" ? false : true
}

resource "fortiflexvm_entitlements_vm" "entitlements_vm_adc_2" {
  for_each = local.environments

  config_id     = data.fortiflexvm_entitlements_list.entitlements_list["${each.value.username}_adc_2"].entitlements[0].config_id
  serial_number = data.fortiflexvm_entitlements_list.entitlements_list["${each.value.username}_adc_2"].entitlements[0].serial_number
  status        = "ACTIVE"
}

resource "fortiflexvm_entitlements_vm_token" "entitlements_vm_token_vm_adc_2" {
  for_each = local.environments

  config_id        = data.fortiflexvm_entitlements_list.entitlements_list["${each.value.username}_adc_2"].entitlements[0].config_id
  serial_number    = data.fortiflexvm_entitlements_list.entitlements_list["${each.value.username}_adc_2"].entitlements[0].serial_number
  regenerate_token = data.fortiflexvm_entitlements_list.entitlements_list["${each.value.username}_adc_2"].entitlements[0].token_status == "USED" && data.fortiflexvm_entitlements_list.entitlements_list[each.key].entitlements[0].status == "ACTIVE" ? false : true
}

output "entitlements_vm_adc_1" {
  value = var.output_enabled ? fortiflexvm_entitlements_vm.entitlements_vm_adc_1[*] : []
}

output "entitlements_vm_token_adc_1" {
  value = var.output_enabled ? fortiflexvm_entitlements_vm_token.entitlements_vm_token_vm_adc_1[*] : []
}

output "entitlements_vm_adc_2" {
  value = var.output_enabled ? fortiflexvm_entitlements_vm.entitlements_vm_adc_2[*] : []
}

output "entitlements_vm_token_adc_2" {
  value = var.output_enabled ? fortiflexvm_entitlements_vm_token.entitlements_vm_token_vm_adc_2[*] : []
}

output "bastion_shareable_link" {
  value = [for key, rg in module.module_appsec-102-203 : format("%s, %s, %s", key, var.password, rg.bastion_shareable_links.value[0].bsl)]
}