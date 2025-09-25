// PoC top-level Terragrunt configuration
locals {
  project = "Web.Accentry"
  owner   = "Accell-IT-B-V"

  // From examples/default_locals.tf
  env_name         = get_env("TG_ENV", "dev")  // Allow override via env var or set in env files
  az_region        = "westeurope"
  project_name     = "accentry"
  application_name = "poc"
  name_prefix      = "${local.env_name}-${local.project_name}-${local.application_name}"

  default_tags = {
    project_name        = "accentry"
    owner               = "web"
    environment         = local.env_name
    region              = local.az_region
    application_name    = local.application_name
    managed_by          = "terraform"
    created_date        = formatdate("YYYY-MM-DD", timestamp())
    "Application Name"   = local.application_name
    "Business Criticality" = "Low"
  }

  // Tags helper: merge default_tags with additional_tags
  additional_tags = {}  // Can be overridden in env files
  merged_tags = merge(local.default_tags, local.additional_tags)
}

terraform {
  # Point to a shared module registry or local modules. Placeholder for PoC.
  source = "./modules//example"
}

inputs = {
  project = local.project
  owner   = local.owner
  env_name = local.env_name
  az_region = local.az_region
  project_name = local.project_name
  application_name = local.application_name
  name_prefix = local.name_prefix
  tags = local.merged_tags
}
