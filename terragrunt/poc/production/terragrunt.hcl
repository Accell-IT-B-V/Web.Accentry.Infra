// Production environment Terragrunt configuration (PoC)
include {
  path = find_in_parent_folders()
}

locals {
  env = "prod"
  additional_tags = {
    environment = local.env
    "Business Criticality" = "High"  // Override for production
  }
}

inputs = merge(local.inputs, {
  env_name = local.env
  additional_tags = local.additional_tags
})
