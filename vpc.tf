resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/24"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "wordpress-vpc"
    env  = var.env
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "wordpress-igw"
    env  = var.env
  }
}

resource "aws_eip" "eip" {
  vpc        = true
  count      = 2
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "nat" {
  count         = 2
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  tags = {
    Name = "wordpress-nat-gw-${count.index + 1}"
    Env  = var.env
  }
}

data "aws_availability_zones" "azs" {
  state = "available"
}

locals {
  azs = data.aws_availability_zones.azs.names
}

variable "subnets_cidr_blocks" {
  type        = list(string)
  description = "List of cidr blocks for each subnet within the vpc range"
  default     = ["10.0.0.0/26", "10.0.0.64/26", "10.0.0.128/26", "10.0.0.192/26"]
}

resource "aws_subnet" "public_subnets" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnets_cidr_blocks[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "wordpress-public-${count.index + 1}"
    Env  = var.env
  }
}

resource "aws_subnet" "private_subnets" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnets_cidr_blocks[count.index + 2]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "wordpress-private-${count.index + 1}"
    Env  = var.env
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-rt"
    Env  = var.env
  }
}

resource "aws_route_table_association" "public-rt-as" {
  count          = 2
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  count  = 2

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name = "private-rt-${count.index}"
    env  = var.env
  }
}

resource "aws_route_table_association" "private-rt-as" {
  count          = 2
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}
