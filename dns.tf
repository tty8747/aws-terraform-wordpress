data "cloudflare_zone" "ubu" {
  name = "ubukubu.ru"
}

resource "cloudflare_record" "wp" {
  zone_id = data.cloudflare_zone.ubu.zone_id
  name    = "wp1"
  value   = "1.2.3.4"
  type    = "A"
  ttl     = 1
  proxied = true
}
