locals {
  # Defaults
  #   env          = upper(var.env)
  namespace    = module.common.namespace
  default_tags = merge(module.common.default_tags, { "Namespace" : local.namespace, "AppRole" : "Network" })
  name_prefix  = local.namespace

  # Data Source to local mapping
  network_remote_state = data.terraform_remote_state.this.outputs


  # Resource Naming Conventions
  alpha    = "${local.name_prefix}-alpha"
  beta     = "${local.name_prefix}-beta"
  delta    = "${local.name_prefix}-delta"
  alpha_sg = "${local.name_prefix}-alpha-sg"
  beta_sg  = "${local.name_prefix}-beta-sg"
  delta_sg = "${local.name_prefix}-delta-sg"

}