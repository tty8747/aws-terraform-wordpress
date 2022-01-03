resource "aws_key_pair" "helper_key" {
  key_name   = "helper_key"
  public_key = file(var.path_to_helper_key)
}

data "aws_ami" "rocky" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["Rocky-8-ec2-8.5-20211114.2.x86_64*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }
}

resource "aws_instance" "helper" {
  ami           = data.aws_ami.rocky.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.helper_key.id

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.public_helper_eth.id
  }

  network_interface {
    device_index = 1
    network_interface_id = aws_network_interface.helper_eth.id
  }

  tags = {
    Name = var.instance
  }
}

resource "aws_network_interface" "public_helper_eth" {
  subnet_id       = aws_subnet.helper.id
  security_groups = [aws_security_group.helper.id]

  tags = {
    Name = "Public network interface"
  }
}

resource "aws_network_interface" "helper_eth" {
# count           = length(var.subnets)
# subnet_id       = var.subnets[count.index].id
# security_groups = [aws_security_group.helper.id]
 
  subnet_id       = var.subnets.id
# security_groups = [aws_security_group.helper.id]

  tags = {
    Name = "Private network interface for var.subnets"
  }
}
