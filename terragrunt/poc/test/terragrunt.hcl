// Test environment Terragrunt configuration (PoC)
include {
  path = find_in_parent_folders()
}

locals {
  env = "test"
  additional_tags = {
    environment = local.env
  }
}

inputs = merge(local.inputs, {
  env_name = local.env
  additional_tags = local.additional_tags
})
