# Helper function to merge default tags with resource-specific tags
locals {
  # Function to merge default tags with additional tags
  merged_tags = {
    for key, value in merge(local.default_tags, var.additional_tags) : key => value
  }
}

# Variable for additional tags that can be passed to resources
variable "additional_tags" {
  description = "Additional tags to merge with default tags"
  type        = map(string)
  default     = {}
}

# Output the merged tags for use in resources
output "tags" {
  description = "Merged default and additional tags"
  value       = local.merged_tags
}