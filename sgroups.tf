resource "aws_security_group" "rset" {
  name        = "rset"
  description = "Set of rules"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "rset"
  }
}

resource "aws_security_group_rule" "keys" {
  type              = "ingress"
  for_each          = var.allowed_ports
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.main.cidr_block]
  security_group_id = aws_security_group.rset.id
  description       = each.key
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rset.id
}

resource "aws_security_group" "efs" {
  name   = "efs"
  vpc_id = aws_vpc.main.id
  # https://www.terraform.io/language/expressions/for#result-types
  # https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9
  for_each = { for k, v in var.allowed_ports : k => v if k == "efs" }

  ingress {
    description = "efs from VPC"
    from_port   = each.value
    to_port     = each.value
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = each.value
    to_port     = each.value
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  tags = {
    Name = "allow only efs traffic"
  }

}
