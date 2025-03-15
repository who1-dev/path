resource "aws_iam_user" "alpha" {
  for_each = var.alpha_users
  name    = each.value.username

  tags = merge(local.default_tags, {
    "access-project" = "alpha"
    "access-role"    = each.value.role
  })
}

resource "aws_iam_user" "beta" {
  for_each = var.beta_users
  name    = each.value.username

  tags = merge(local.default_tags, {
    "access-project" = "beta"
    "access-role"    = each.value.role
  })
}


resource "aws_iam_user" "delta" {
  for_each = var.delta_users
  name    = each.value.username

  tags = merge(local.default_tags, {
    "access-project" = "delta"
    "access-role"    = each.value.role
  })
}
