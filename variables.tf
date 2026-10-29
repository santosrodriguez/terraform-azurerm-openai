variable "environment" {
  type = string
}

variable "eventhub_authorization_rule_id" {
  type        = string
  description = "The Event Hub authorization rule ID for diagnostic settings."
  default     = "/subscriptions/56bdaed4-70cf-4a28-8fb8-0efc135bb29f/resourceGroups/LOGS_RG/providers/Microsoft.EventHub/namespaces/evh-sharedsvcseastus/authorizationRules/RootManageSharedAccessKey"
}

variable "eventhub_name" {
  type        = string
  description = "The Event Hub name for diagnostic settings."
  default     = "cs-resource_resourcelogs"
}

variable "identity_type" {
  type = string
  default = "SystemAssigned"
}

variable "kind" {
  type = string
  default = "OpenAI"
}

variable "location" {
  type = string
  default = "eastus"
}

variable "private_endpoint_subnet_id" {
  type = string
}

variable "private_endpoint_dns_zone_ids" {
  type = list(string)
  default = [ "/subscriptions/56bdaed4-70cf-4a28-8fb8-0efc135bb29f/resourceGroups/rg-azuredns-prd-01/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com" ]
}

variable "private_endpoint_dns_zone_group_name" {
  type = string
  default = "default"
}

variable "public_network_access_enabled" {
  type = bool
  default = false
}

variable "resource_group_name" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "solution_name" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}
