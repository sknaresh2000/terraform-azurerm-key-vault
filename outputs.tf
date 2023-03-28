output "id" {
  value       = azurerm_key_vault.kv.id
  description = "The id of the created key vault"
}

output "vault_uri " {
  value       = azurerm_key_vault.kv.vault_uri
  description = "The URI of the Key Vault, used for performing operations on keys and secrets."
}