resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  count      = length(var.subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnets[count.index]
  # availability_zone = data.aws_availability_zones.available.names[count.index]
  availability_zone = var.av_zones[count.index]

  tags = {
    Name = "main part ${count.index}"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.natSubnet
  availability_zone = var.av_zones[0]

  tags = {
    Name = "Public subnet"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "public" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id     = aws_eip.public.id
  subnet_id         = aws_subnet.public.id
  connectivity_type = "public"

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.public]
}

resource "aws_default_route_table" "public" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }
}

resource "aws_route_table" "toNAT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "route to NAT"
  }
}

resource "aws_route_table_association" "NAT" {
  count          = length(aws_subnet.main.*.id)
  subnet_id      = aws_subnet.main[count.index].id
  route_table_id = aws_route_table.toNAT.id
}
