output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.web.public_ip
}

output "private_key_pem" {
  description = "Private key for SSH access"
  value       = tls_private_key.web_key.private_key_pem
  sensitive   = true
}