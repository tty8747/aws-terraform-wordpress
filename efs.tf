resource "aws_efs_file_system" "wp" {
  creation_token   = "wp-data"
  performance_mode = "generalPurpose"

  tags = {
    Name = "WordPress"
  }
}

resource "aws_efs_mount_target" "main" {
  count          = length(aws_subnet.main.*.id)
  file_system_id = aws_efs_file_system.wp.id
  subnet_id      = aws_subnet.main[count.index].id
}
