// Test environment Terragrunt configuration (PoC)
include {
  path = find_in_parent_folders()
}

locals {
  env = "test"
}

inputs = merge(local.inputs, {
  environment = local.env
  # Add PoC-specific overrides here
})
