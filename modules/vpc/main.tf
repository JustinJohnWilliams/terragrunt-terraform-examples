terraform {
  required_version = ">= 1.2.9"
  backend "s3" {}
}

provider "aws" {
  region              = var.region
  allowed_account_ids = ["${var.aws_account_id}"]
}

locals {
  tags               = merge(var.default_tags, var.tags)
  availability_zones = length(var.availability_zones) > 0 ? var.availability_zones : slice(data.aws_availability_zones.available.zone_ids, 0, 3)
  # All American regions have at least 3 availablity zones, we'll put a public and private subnet in each
  # Public Subnets will be:
  # - 10.100.1.0/24 == 10.100.1.0 ~> 10.100.1.255 (256 hosts)
  # - 10.100.2.0/24 == 10.100.2.0 ~> 10.100.2.255 (256 hosts)
  # - 10.100.4.0/24 == 10.100.4.0 ~> 10.100.4.255 (256 hosts)
  # Private Subnets will be:
  # - 10.100.16.0/20 == 10.100.16.0 ~> 10.100.31.255 (4096 hosts)
  # - 10.100.32.0/20 == 10.100.32.0 ~> 10.100.47.255 (4096 hosts)
  # - 10.100.48.0/20 == 10.100.48.0 ~> 10.100.63.255 (4096 hosts)
  subnets = {
    for index, zone in local.availability_zones : zone => {
      public_octet  = pow(2, index),
      private_octet = 16 * (index + 1),
      zone          = zone
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC resources
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_network_address}.0.0/16"

  tags = merge({
    Name = var.name
  }, local.tags)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name = "${var.name}-igw"
  }, local.tags)
}

# ---------------------------------------------------------------------------------------------------------------------
# Private Subnet resources
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "private" {
  for_each = local.subnets

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.vpc_network_address}.${each.value.private_octet}.0/20"
  availability_zone_id    = each.value.zone
  map_public_ip_on_launch = false

  tags = merge({ Name = "${var.name}_private_${each.key}" }, local.tags)
}

resource "aws_route_table" "private" {
  for_each = local.subnets

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }

  tags = merge({ Name = "${var.name}-${each.key}-private-rt" }, local.tags)
}

resource "aws_route_table_association" "private" {
  for_each = local.subnets

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

# ---------------------------------------------------------------------------------------------------------------------
# Public Subnet resources
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "public" {
  for_each = local.subnets

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.vpc_network_address}.${each.value.public_octet}.0/24"
  availability_zone_id    = each.value.zone
  map_public_ip_on_launch = true

  tags = merge({ Name = "${var.name}_public_${each.key}" }, local.tags)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge({ Name = "${var.name}-public-rt" }, local.tags)
}

resource "aws_route_table_association" "public" {
  for_each = local.subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

# ---------------------------------------------------------------------------------------------------------------------
# NAT Gateway
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_eip" "nat" {
  for_each = local.subnets

  vpc  = true
  tags = merge({ Name = "${var.name}-${each.key}-nat-eip" }, local.tags)
}

resource "aws_nat_gateway" "nat" {
  for_each = local.subnets

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags          = merge({ Name = "${var.name}-${each.key}-nat" }, local.tags)

  depends_on = [aws_internet_gateway.igw]
}

#TODO: add VPC endpoints to s3, dynamodb, rds, kms, etc
