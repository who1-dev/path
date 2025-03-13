variable "default_tags" {
  type        = map(any)
  description = "Default tags to be applied to all Azure resources"
  default = {
    "Name"  = "Pathomics"
    "Owner" = "Trevor"
  }
}

variable "namespace" {
  type    = string
  default = "ppa"
}