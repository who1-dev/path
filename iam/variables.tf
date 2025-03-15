variable "policy_ec2" {
  type        = string
  description = "description"
}

variable "policy_s3" {
  type        = string
  description = "description"
}


variable "alpha_users" {
  description = "description"
  type = map(object({
    username = string
    role     = string
  }))
}

variable "beta_users" {
  description = "description"
  type = map(object({
    username = string
    role     = string
  }))
}

variable "delta_users" {
  description = "description"
  type = map(object({
    username = string
    role     = string
  }))
}
