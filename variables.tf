variable "cloudflare_email" {}
variable "cloudflare_api_key" {}

variable "id_rsa_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to public key"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "cidr" {
  type    = string
  default = "192.168.7.0/24"
}

variable "subnets" {
  type    = list(string)
  default = ["192.168.7.0/25", "192.168.7.128/25"]
}

variable "allowed_ports" {
  description = "Map of allowed ports"
  type        = map(number)
  default = {
    "efs"  = 2049
    "http" = 80
  }
}

variable "instances" {
  type    = list(any)
  default = ["wp_node01", "wp_node02"]
}
