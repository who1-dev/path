locals {
  # Defaults
  #   env          = upper(var.env)
  namespace    = module.common.namespace
  default_tags = merge(module.common.default_tags, { "Namespace" : local.namespace, "AppRole" : "Network" })
  name_prefix  = local.namespace

  # Resource Naming Conventions
  vpc                 = "${local.name_prefix}-vpc"
  igw                 = "${local.name_prefix}-igw"
  public_subnet       = "${local.name_prefix}-public-subnet"
  private_subnet      = "${local.name_prefix}-private-subnet"
  public_route_table  = "${local.name_prefix}-public-route-table"
  nat_eip             = "${local.name_prefix}-eip"
  natgw               = "${local.name_prefix}-natgw"
  private_route_table = "${local.name_prefix}-private-route-table"

  vpcei_ssm    = "${local.name_prefix}-vpc-endpoint-interface-ssm"
  vpcei_ssm_sg = "${local.vpcei_ssm}-sg"
}