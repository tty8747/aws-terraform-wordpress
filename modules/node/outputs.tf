output "public_dns" {
  value = aws_instance.control.*.public_dns
}
