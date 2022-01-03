resource "aws_vpc" "helper" {
  cidr_block = var.cidr
}

resource "aws_subnet" "helper" {
  vpc_id                  = aws_vpc.helper.id
  cidr_block              = var.subnet
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-central-1a"
}

resource "aws_internet_gateway" "helper" {
  vpc_id = aws_vpc.helper.id
}

resource "aws_default_route_table" "helper" {
  default_route_table_id = aws_vpc.helper.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.helper.id
  }
}
