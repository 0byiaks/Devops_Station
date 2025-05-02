output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "web_server_public_ip" {
  description = "Public IP address of the web server"
  value       = module.webserver.public_ip
}

output "db_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = module.database.db_instance_endpoint
}

output "web_url" {
  description = "URL to access the web server"
  value       = "http://${module.webserver.public_ip}"
}

output "ssh_connection_command" {
  description = "Command to SSH into the EC2 instance"
  value       = "ssh -i web_key.pem ubuntu@${module.webserver.public_ip}"
}