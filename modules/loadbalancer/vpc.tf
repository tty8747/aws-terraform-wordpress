resource "aws_subnet" "this" {
  for_each   = var.lbsubnets
  vpc_id     = var.vpc.id
  cidr_block = each.value
  # availability_zone = data.aws_availability_zones.available.names[count.index]
  availability_zone = each.key

  tags = {
    Name = "Load Balancer subnet ${each.key}"
  }
}

resource "aws_route_table" "this" {
  vpc_id = var.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway.id
  }

  tags = {
    Name = "lb route table"
  }
}
