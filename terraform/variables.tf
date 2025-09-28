# -- Workload specific variables --
variable "subscription_id" {
  description = "The Subscription ID which should be used to deploy resources in to."
  type        = string
}

variable "org_prefix" {
  description = "Prefix for the organisation, to be used for naming and tags for all resources created."
  type        = string
  default     = "qc"
}

variable "environment" {
  description = "The environment for the deployment (e.g., dev, test, prod)."
  type        = string
  default     = "dev"
}

variable "workload" {
  description = "Configuration details for the workload being deployed."
  type = object({
    slug       = string
    short_name = string
  })
  default = {
    slug       = "rdf-foundations-terraform"
    short_name = "rdftf"
  }
}

variable "location" {
  type = object({
    name       = string
    short_code = string
  })
  default = {
    name       = "UK South"
    short_code = "uks"
  }
}

# -- Storage Account variables --
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
