variable "cloudflare_email" {}
variable "cloudflare_api_key" {}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "cidr" {
  type    = string
  default = "192.168.7.0/24"
}

variable "subnet" {
  type    = string
  default = "192.168.7.0/25"
}
