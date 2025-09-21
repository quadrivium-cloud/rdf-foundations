variable "subscription_id" {
  type = string
}

variable "resource_group_name" {
  type    = string
  default = "rg-rdf-foundations-terraform"
}

variable "resource_group_location" {
  type    = string
  default = "UK South"
}

variable "name" {
  type = string
}

variable "sku_tier" {
  type = string
}

variable "access_tier" {
  type = string
}

variable "accountReplication" {
  type = string
}

variable "publicNetworkAccess" {
  type = bool
}

variable "allowBlobPublicAccess" {
  type = bool
}

variable "blobSoftDeleteRetentionDays" {
  type = number
}
