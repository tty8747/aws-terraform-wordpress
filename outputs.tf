output "instance_ip_addr" {
  value       = data.cloudflare_zone.ubu
  description = "The dns zone of the main server instance."
}

output "zones" {
  value = data.aws_availability_zones.available.names.*
}

output "efs_targets" {
  value = aws_efs_mount_target.main.*
}

output "lb_dns_name" {
  value = module.loadbalancer.lb_dns_name
}

output "db_endpoint" {
  value = module.db.db_endpoint
}
