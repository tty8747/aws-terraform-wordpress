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
  default = "192.168.0.0/16"
  # default = "192.168.7.0/24"
  description = "CIDR for vpc"
}

variable "subnets" {
  type    = list(string)
  default = ["192.168.7.0/24", "192.168.77.0/24"]
  # default = ["192.168.7.0/25", "192.168.7.128/25"]
}

variable "av_zones" {
  type    = list(string)
  default = ["eu-central-1a", "eu-central-1b"]
}

variable "natSubnet" {
  type    = string
  default = "192.168.99.0/24"
  # default = "192.168.7.32/28"
}

variable "allowed_ports" {
  description = "Map of allowed ports"
  type        = map(number)
  default = {
    "efs"  = 2049
    "http" = 8080
    "ssh"  = 22
  }
}

variable "instances" {
  type    = list(any)
  default = ["wp_node01", "wp_node02"]
}

variable "wplogin" {
  type    = string
  default = "wpdb"
}

variable "wppassword" {
  type    = string
  default = "wpdbpass"
}
