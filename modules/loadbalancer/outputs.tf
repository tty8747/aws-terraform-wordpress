output "lb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "Load balancer dns-name"
}

