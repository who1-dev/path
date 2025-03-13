locals {
  # Defaults
  #   env          = upper(var.env)
  namespace    = module.common.namespace
  default_tags = merge(module.common.default_tags, { "Namespace" : local.namespace, "AppRole" : "Network" })
  name_prefix  = local.namespace

  # Data Source to local mapping
  network_remote_state = data.terraform_remote_state.this.outputs


  # Resource Naming Conventions
  vm1   = "${local.name_prefix}-vm1"
  vm2   = "${local.name_prefix}-vm2"
  vm3   = "${local.name_prefix}-vm3"
  vm_sg = "${local.name_prefix}-vm-sg"

}