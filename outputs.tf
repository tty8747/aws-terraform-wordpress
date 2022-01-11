output "efs_targets" {
  value = aws_efs_mount_target.main.*.mount_target_dns_name
}

output "lb_dns_name" {
  value = module.loadbalancer.lb_dns_name
}

output "db_endpoint" {
  value = module.db.db_endpoint
}

output "http_address" {
  value = "DNS-NAME: ${cloudflare_record.wp.hostname}"
}

output "private_dns" {
  value = aws_instance.web.*.private_dns
}

output "public_dns" {
  value = module.node.public_dns
}

output "how-to" {
  value = "ssh -J ubuntu@<public_dns> -l ubuntu <private_dns or asg-private-ips>"
}
