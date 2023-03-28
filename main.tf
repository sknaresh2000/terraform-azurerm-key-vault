data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                          = var.name
  resource_group_name           = var.rg_name
  location                      = var.location
  enabled_for_disk_encryption   = var.enabled_for_disk_encryption
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  sku_name                      = var.sku_name
  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags
  dynamic "network_acls" {
    for_each = var.public_network_access_enabled == false && var.network_acls != null ? [1] : []
    content {
      bypass                     = var.network_acls.bypass_services_info
      default_action             = var.network_acls.default_action
      ip_rules                   = var.network_acls.allowed_ips
      virtual_network_subnet_ids = var.network_acls.service_endpoint_subnet_ids
    }
  }
}

resource "azurerm_private_endpoint" "pe" {
  name                = format("%s-%s", var.name, "private-endpoint")
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.private_endpoint_subnet_id
  private_service_connection {
    name                           = format("%s-%s", var.name, "private-service-connection")
    private_connection_resource_id = azurerm_key_vault.kv.id
    is_manual_connection           = var.is_manual_connection
    subresource_names              = var.private_endpoint_kv_subresource_names
  }
}

resource "azurerm_key_vault_access_policy" "access_policies" {
  for_each                = var.access_policies
  key_vault_id            = azurerm_key_vault.kv.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = each.value.object_id
  key_permissions         = each.value.key_permissions
  secret_permissions      = each.value.secret_permissions
  certificate_permissions = each.value.certificate_permissions
}