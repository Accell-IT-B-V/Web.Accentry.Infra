locals {
    # Common varibales to use in project
    env_name         = "dev"
    az_region        = "westeurope"
    project_name     = "accentry"
    application_name = "poc"

    # name_prefix which will use in resource naming convention
    name_prefix      = "${local.env_name}-${local.project_name}-${local.application_name}"

    # These tags are being used in all terraform resources and can be add more
    default_tags = {
        project_name        = "accentry"
        owner               = "web"
        environment         = local.env_name
        region              = local.az_region
        application_name    = local.application_name
        managed_by          = "terraform"
        created_date        = formatdate("YYYY-MM-DD", timestamp())
        # Required by Azure Policy
        "Application Name"   = local.application_name
        # Required by policy - options: Critical, High, Medium, Low
        "Business Criticality" = "Low"        
    }
}