resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_network_interface" "public" {
  subnet_id       = var.external.id
  security_groups = var.public_sgroups_ids

  tags = {
    Name = "Public network interface"
  }
}

resource "aws_eip_association" "eip_assoc" {
  allocation_id        = aws_eip.eip.id
  network_interface_id = aws_network_interface.public.id
}

resource "aws_network_interface" "private" {
  subnet_id       = var.internal.id
  security_groups = var.private_sgroups_ids

  tags = {
    Name = "Private network interface"
  }
}

resource "aws_instance" "control" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_id

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.public.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.private.id
  }

  tags = {
    Name     = "helper to discovery private network"
    HowToUse = "ssh -J ubuntu@<control-node-ip> -lubuntu <private-node-ip-address>"
  }
}
