// Production environment Terragrunt configuration (PoC)
include {
  path = find_in_parent_folders()
}

locals {
  env = "production"
}

inputs = merge(local.inputs, {
  environment = local.env
  # Add production-specific overrides here
})
