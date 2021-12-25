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

resource "aws_key_pair" "my" {
  key_name   = "id_rsa.pub from home pc"
  public_key = file(var.path_to_mykey)
}

resource "aws_instance" "web" {
  count = length(var.instances)
  ami           = data.aws_ami.ubuntu20.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my.id
  associate_public_ip_address = false

  tags = {
    Name = var.instances[count.index]
  }
}

