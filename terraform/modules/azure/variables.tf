variable "vm_username" {
  description = "Username for the admin user on VMs"
  type        = string
}
variable "password" {
  description = "Password for the admin user"
  type        = string
}
variable "rg_prefix" {
  description = "The prefix to use for all resource group names"
  type        = string
}

variable "location" {
  description = "Azure location for resources"
  type        = string
  default     = ""
}

variable "rg_suffix" {
  description = "Suffix for the resource group name"
  type        = string
  default     = ""
}

variable "fortiflexvm_config_id" {
  description = "The FortiFlexVM config ID to use for this deployment"
  type        = string
}

variable "fortiflex_serial_numbers" {
  description = "Map of ADC FortiFlexVM serial numbers"
  type        = map(any)
}

variable "fortiflex_access_username" {
  description = "FortiFlexVM Access Username"
  type        = string
  default     = ""
}

variable "fortiflex_access_password" {
  description = "FortiFlexVM Access Password"
  type        = string
  default     = ""
}