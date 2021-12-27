resource "aws_vpc" "main" {
  cidr_block = var.cidr

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  count             = length(var.subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "main part ${count.index}"
  }
}
