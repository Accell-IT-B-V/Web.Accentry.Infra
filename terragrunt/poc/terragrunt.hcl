// PoC top-level Terragrunt configuration
locals {
  project = "Web.Accentry"
  owner   = "Accell-IT-B-V"
}

terraform {
  # Point to a shared module registry or local modules. Placeholder for PoC.
  source = "./modules//example"
}

inputs = {
  project = local.project
  owner   = local.owner
}
