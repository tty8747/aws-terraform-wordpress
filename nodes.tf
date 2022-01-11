data "aws_ami" "ubuntu20" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "hcypress" {
  key_name   = "id_rsa.pub from home pc"
  public_key = file(var.id_rsa_path)
}

resource "aws_network_interface" "eth" {
  count           = length(var.instances)
  subnet_id       = aws_subnet.main[count.index].id
  security_groups = [aws_security_group.rset.id]

  tags = {
    Name = "Private network interface"
  }
}

resource "aws_instance" "web" {
  count         = length(var.instances)
  ami           = data.aws_ami.ubuntu20.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.hcypress.id
  user_data     = data.template_file.init.rendered

  network_interface {
    network_interface_id = aws_network_interface.eth[count.index].id
    device_index         = 0
  }

  tags = {
    Name = var.instances[count.index]
  }
}
