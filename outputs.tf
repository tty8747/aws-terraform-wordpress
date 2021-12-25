output "instance_ip_addr" {
  value       = data.cloudflare_zone.ubu
  description = "The dns zone of the main server instance."
}

