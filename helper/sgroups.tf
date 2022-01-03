resource "aws_security_group" "helper" {
  name        = "helper"
  description = "Allow all"
  vpc_id      = aws_vpc.helper.id
}

resource "aws_security_group_rule" "helper_ingress_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0 
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.helper.id
}

resource "aws_security_group_rule" "helper_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0 
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.helper.id
}
