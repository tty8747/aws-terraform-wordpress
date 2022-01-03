data "template_file" "init" {
  template = file("templates/init.tpl")
  vars = {
    efs_id = "${aws_efs_file_system.wp.id}"
  }
}
