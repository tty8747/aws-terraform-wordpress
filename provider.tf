terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "tty8747"

}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

module "node" {
  source              = "./modules/node"
  av_zone             = "eu-central-1a"
  external            = aws_subnet.public
  internal            = aws_subnet.main[0]
  public_sgroups_ids  = [aws_security_group.ssh.id]
  private_sgroups_ids = [aws_security_group.rset.id]
  ami_id              = data.aws_ami.ubuntu20.id
  key_id              = aws_key_pair.hcypress.id
}

module "loadbalancer" {
  source              = "./modules/loadbalancer"
  lbname              = "wploadbalancer"
  gateway             = aws_internet_gateway.public
  lbsubnets           = var.lbsubnets
  internal_port       = 8080
  usefullsubnets      = [for i in aws_subnet.main : i.id]
  target_ids          = [for i in aws_instance.web.*.id : i]
  vpc                 = aws_vpc.main
  ami_id              = data.aws_ami.ubuntu20.id
  key_id              = aws_key_pair.hcypress.id
  private_sgroups_ids = [aws_security_group.rset.id]
  init-script         = data.template_file.init.rendered
}

module "db" {
  source         = "./modules/rds"
  db_engine      = "MariaDB"
  db_engineVer   = "10.5"
  db_name        = var.wplogin
  db_user        = var.wplogin
  db_pass        = var.wppassword
  av_zone        = "eu-central-1b"
  vpc            = aws_vpc.main
  db_subnet_list = [for i in aws_subnet.main : i.id]
  s_group        = aws_security_group.rset
}
