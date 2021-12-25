variable "cloudflare_email" {}
variable "cloudflare_api_key" {}


variable "path_to_mykey" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to tty8747 public key"
}

variable "instances" {
  type = list
  default = ["wp_node01", "wp_node02"]
}

# variable "lbname" {}
