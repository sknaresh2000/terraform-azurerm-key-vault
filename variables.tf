variable "rg_name" {
  type        = string
  description = "The name of the resource group where the resources should be created"
}

variable "name" {
  type        = string
  description = "The name of the key vault to create"
}

variable "location" {
  type        = string
  description = "The location of key vault that will be created"
  default     = "eastus"
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  default     = true
}

variable "soft_delete_retention_days" {
  type        = number
  description = "The number of days that items should be retained for once soft-deleted. "
  default     = 7
}

variable "tags" {
  type        = map(any)
  description = "Mapping of Tags"
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Is Purge Protection enabled for this Key Vault?"
  default     = false
}

variable "sku_name" {
  type        = string
  description = " The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  default     = "standard"
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether the public network access is enabled?"
  default     = false
}

variable "network_acls" {
  type = object({
    bypass_services_info        = list(string)
    default_action              = string
    allowed_ips                 = list(string)
    service_endpoint_subnet_ids = list(string)
  })
  description = "Network & Firewall settings for key vault"
  default     = null
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Details of the subnet id where the private endpoint needs to be configured"
}

variable "is_manual_connection" {
  type        = string
  description = "Does the Private Endpoint require Manual Approval from the remote resource owner?"
  default     = false
}

variable "private_endpoint_kv_subresource_names" {
  type        = list(string)
  description = "A list of subresource names which the Private Endpoint is able to connect to."
  default     = ["vault"]
}

variable "access_policies" {
  type = map(object({
    object_id               = string
    key_permissions         = list(string)
    secret_permissions      = list(string)
    certificate_permissions = list(string)
  }))
  description = "Access policies that will be applies to this key vault"
  default     = {}
}