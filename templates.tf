data "template_file" "init" {
  template = file("templates/init.tpl")
  vars = {
    efs_id            = aws_efs_file_system.wp.id
    MAINDB            = var.wplogin
    PASSWDDB          = var.wppassword
    WORDPRESS_DB_HOST = module.db.db_endpoint
  }
}
