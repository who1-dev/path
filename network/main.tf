module "common" {
  source = "../.common"
}

# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.default_tags, {
    Name = "${local.vpc}"
  })
}

# IGW
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(local.default_tags, {
    Name = "${local.igw}"
  })

  depends_on = [aws_vpc.this]
}


# PUBLIC SUBNET 
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[0]

  tags = merge(local.default_tags, {
    Name = "${local.public_subnet}"
  })

  depends_on = [aws_vpc.this]
}

# PRIVATE SUBNETS
resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zones[count.index]

  tags = merge(local.default_tags, {
    Name = "${local.private_subnet}-${count.index + 1}"
  })

  depends_on = [aws_vpc.this]
}

# PUBLIC ROUTE TABLE
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.default_tags, {
    Name = "${local.public_route_table}"
  })

  depends_on = [aws_vpc.this]
}

# PUBLIC ROUTE TABLE - ROUTE
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  depends_on = [aws_route_table.public]
}

# PUBLIC ROUTE TABLE - ASSOCIATION
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id

  depends_on = [aws_route_table.public]
}

# ELASTIC IP ADDRESS
resource "aws_eip" "nat" {
  tags = merge(local.default_tags, {
    Name = "${local.nat_eip}"
  })

  depends_on = [aws_vpc.this]
}

# NATGW
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = merge(local.default_tags, {
    Name = "${local.natgw}"
  })

  depends_on = [aws_eip.nat]
}

# PRIVATE ROUTE TABLE
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.default_tags, {
    Name = "${local.private_route_table}"
  })

  depends_on = [aws_vpc.this]

}

# PUBLIC ROUTE TABLE - ROUTE
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id

  depends_on = [aws_route_table.private]
}

# PUBLIC ROUTE TABLE - ASSOCIATION
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id

  depends_on = [aws_route_table.private]
}

