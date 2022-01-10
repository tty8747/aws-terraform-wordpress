resource "aws_db_instance" "this" {
  allocated_storage     = 5
  max_allocated_storage = 12
  engine                = var.db_engine    # MariaDB
  engine_version        = var.db_engineVer # 10.5
  instance_class        = "db.t2.micro"
  name                  = var.db_name
  username              = var.db_user
  password              = var.db_pass
  # parameter_group_name  = "this.${var.db_engine}.${var.db_engineVer}"
  skip_final_snapshot = true
  availability_zone   = var.av_zone
  # vpc_security_group_ids = [aws_db_security_group.this.id]
  db_subnet_group_name   = aws_db_subnet_group.this.id
  vpc_security_group_ids = [var.s_group.id]
}

resource "aws_db_subnet_group" "this" {
  name       = "this"
  subnet_ids = var.db_subnet_list

  tags = {
    Name = "Subnet group for ${var.db_name}"
  }
}

resource "aws_security_group_rule" "db_port" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [var.vpc.cidr_block]
  security_group_id = var.s_group.id
  description       = "for db"
}

