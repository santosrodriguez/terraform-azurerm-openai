terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  numeric  = true
  special = false
  lower = false
}

data "azurecaf_name" "openai_name" {
  resource_type = "azurerm_cognitive_account"
  suffixes = [ var.solution_name, var.location, var.environment, random_string.suffix.result ]
}

resource "azurerm_cognitive_account" "openai" {
  location = var.location
  name = data.azurecaf_name.openai_name.result
  resource_group_name = var.resource_group_name
  kind = var.kind
  sku_name = var.sku_name
  public_network_access_enabled = var.public_network_access_enabled
  custom_subdomain_name = data.azurecaf_name.openai_name.result
  network_acls {
    default_action = "Allow"
    bypass = "None"
  }
  identity {
    type = var.identity_type
  }
}

resource "azurerm_private_endpoint" "pep" {
  name = "pe-${azurerm_cognitive_account.openai.name}"
  location = azurerm_cognitive_account.openai.location
  resource_group_name = azurerm_cognitive_account.openai.resource_group_name
  subnet_id = var.private_endpoint_subnet_id
  private_service_connection {
    is_manual_connection = false
    name = "pe-connection-${azurerm_cognitive_account.openai.name}"
    private_connection_resource_id = azurerm_cognitive_account.openai.id
    subresource_names = ["account"]
  }
  private_dns_zone_group {
    name = var.private_endpoint_dns_zone_group_name
    private_dns_zone_ids = var.private_endpoint_dns_zone_ids
  }
  depends_on = [ azurerm_cognitive_account.openai ]
}

resource "azurerm_monitor_diagnostic_setting" "diag_setting" {
  name = "diagsetting-${azurerm_cognitive_account.openai.name}"
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id
  eventhub_name = var.eventhub_name
  target_resource_id = azurerm_cognitive_account.openai.id
  enabled_log {
    category = "AuditEvent"
  }
  depends_on = [ azurerm_cognitive_account.openai ]
}
