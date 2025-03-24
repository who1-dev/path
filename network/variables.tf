variable "vpc_cidr_block" {
  type = string
}

# Variables for public and private subnets
variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}