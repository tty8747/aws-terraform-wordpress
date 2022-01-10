output "instance_ip_addr" {
  value       = data.cloudflare_zone.example
  description = "The dns zone of the main server instance."
}

output "zones" {
  value = data.aws_availability_zones.available.names.*
}

output "efs_targets" {
  value = aws_efs_mount_target.main.*
}

output "db_endpoint" {
  value = module.db.db_endpoint
}
