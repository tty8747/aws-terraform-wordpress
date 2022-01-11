data "cloudflare_zone" "ubu" {
  name = var.domain
}

resource "cloudflare_record" "wp" {
  zone_id = data.cloudflare_zone.ubu.zone_id
  name    = "wp"
  value   = module.loadbalancer.lb_dns_name
  type    = "CNAME"
  ttl     = 1
  proxied = true
}
