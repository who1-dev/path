resource "aws_iam_group" "alpha" {
  name = "alpha"
}

resource "aws_iam_group" "beta" {
  name = "beta"
}

resource "aws_iam_group" "delta" {
  name = "delta"
}


resource "aws_iam_group_membership" "alpha_associ" {
  name  = "alpha-group-membership"
  users = [for user in aws_iam_user.alpha : user.name]

  group = aws_iam_group.alpha.name
}

resource "aws_iam_group_membership" "beta_associ" {
  name  = "beta-group-membership"
  users = [for user in aws_iam_user.beta : user.name]
  group = aws_iam_group.beta.name
}

resource "aws_iam_group_membership" "delta_associ" {
  name  = "delta-group-membership"
  users = [for user in aws_iam_user.delta : user.name]

  group = aws_iam_group.delta.name
}