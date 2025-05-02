# EC2 Connection Troubleshooting Guide

If you're having trouble connecting to your EC2 instance, here are some common issues and solutions:

## 1. Permission Issues with Private Key

The private key file must have restricted permissions:

```bash
# Set the correct permissions on the key file
chmod 600 web_key.pem
```

## 2. Security Group Configuration

Ensure that port 22 (SSH) is open in your security group:

```bash
# Check the security group rules
terraform state show module.security.aws_security_group.web
```

Look for an ingress rule allowing TCP port 22.

## 3. Instance Not Running

Verify that your EC2 instance is running:

```bash
# Check the instance state
terraform state show module.webserver.aws_instance.web | grep "instance_state"
```

## 4. Using the Wrong Username

Different AMIs use different default usernames:
- Amazon Linux 2: `ec2-user`
- Ubuntu: `ubuntu`
- RHEL: `ec2-user` or `root`
- Debian: `admin` or `root`

Make sure you're using the correct username for your AMI.

## 5. Network Connectivity

Ensure your local network allows outbound connections on port 22.

## 6. Elastic IP Association

Verify that the Elastic IP is correctly associated with your instance:

```bash
# Check the EIP association
terraform state show module.webserver.aws_eip.web
```

## 7. VPC and Subnet Configuration

Ensure your instance is in a public subnet with a route to an Internet Gateway:

```bash
# Check the subnet configuration
terraform state show module.network.aws_subnet.public
```

## 8. DNS Resolution

If you're using a domain name, ensure DNS is resolving correctly:

```bash
# Check DNS resolution
nslookup your-domain.com
```

## 9. SSH Client Issues

Try connecting with verbose output to see more details about the connection attempt:

```bash
ssh -v -i web_key.pem ubuntu@<public_ip>
```

## 10. Instance Initialization

The instance might still be initializing. Wait a few minutes and try again.

## 11. Regenerate Key Pair

If all else fails, you might need to recreate the key pair:

```bash
# Remove the current key pair resources
terraform taint module.webserver.aws_key_pair.web_key
terraform taint module.webserver.tls_private_key.web_key
terraform taint module.webserver.local_file.private_key

# Apply the changes
terraform apply
```

This will create a new key pair and update the instance to use it.