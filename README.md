# Terraform AWS Infrastructure Project

This project uses Terraform to deploy a modular AWS infrastructure including:
- VPC with public and private subnets
- EC2 web server with Apache and PHP
- RDS MySQL database
- Security groups and networking components

## Project Structure

```
.
├── main.tf                 # Root module that calls all submodules
├── provider.tf             # Provider configuration
├── backend.tf              # Backend configuration (commented out)
├── variables.tf            # Root module variables
├── outputs.tf              # Root module outputs
├── terraform.tfvars        # Variable values (not included in repo)
├── modules/
│   ├── network/            # Network module (VPC, subnets, etc.)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security/           # Security module (security groups)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── database/           # Database module (RDS)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── webserver/          # Webserver module (EC2)
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── user_data.tpl   # User data template for EC2
```

## Architecture

This project follows a modular approach with:
- Root module: Contains only module calls and high-level configuration
- Child modules:
  - Network module: VPC, subnets, route tables, internet gateway
  - Security module: Security groups for web server and database
  - Database module: RDS MySQL instance and related resources
  - Webserver module: EC2 instance, key pair, and Elastic IP

## Usage

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Review the plan:
   ```
   terraform plan
   ```

3. Apply the configuration:
   ```
   terraform apply
   ```

4. Access the web server:
   After deployment, the web server's public IP will be displayed in the outputs.
   You can access it via: `http://<web_server_public_ip>`

5. Connect to the EC2 instance:
   After deployment, you have two options to connect to your EC2 instance:

   **Option 1:** Use the provided script:
   ```
   # Make the script executable
   chmod +x connect_to_ec2.sh
   
   # Run the script
   ./connect_to_ec2.sh
   ```

   **Option 2:** Use the SSH command from terraform output:
   ```
   # Get the SSH command
   terraform output ssh_connection_command
   
   # Then copy and execute the displayed command:
   ssh -i web_key.pem ubuntu@<web_server_public_ip>
   ```

6. To destroy the infrastructure:
   ```
   terraform destroy
   ```

## Notes

- The private key for SSH access is automatically saved to `web_key.pem` with the required permissions (0600).

- If you encounter any issues connecting to your EC2 instance, refer to the [EC2 Connection Troubleshooting Guide](./EC2_CONNECTION_TROUBLESHOOTING.md).

- To test the database connection, visit:
  ```
  http://<web_server_public_ip>/dbtest.php
  ```