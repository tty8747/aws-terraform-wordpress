output "instance_ip_addr" {
  value       = data.cloudflare_zone.example
  description = "The dns zone of the main server instance."
}

