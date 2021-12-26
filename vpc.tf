resource "aws_vpc" "main" {
  cidr_block = var.cidr

  tags = {
    name = "main"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    name = "main"
  }
}
