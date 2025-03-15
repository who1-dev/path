locals {
  # Defaults
  #   env          = upper(var.env)
  namespace    = module.common.namespace
  default_tags = merge(module.common.default_tags, { "Namespace" : local.namespace, "AppRole" : "IAM" })
  name_prefix  = local.namespace

  # Resource Naming Conventions
}