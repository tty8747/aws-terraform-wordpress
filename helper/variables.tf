variable "path_to_helper_key" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to helper key"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet" {
  type    = string
  default = "10.0.0.0/16"
}

variable "instance" {
  type    = string
  default = "helper"
}

variable "subnets" {}
