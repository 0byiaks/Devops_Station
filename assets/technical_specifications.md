# Technical Specifications

## Infrastructure Components

### Network Configuration
- **VPC**: Custom VPC with user-defined CIDR block
- **Subnets**:
  - Public subnet for web servers
  - Private subnet for database
  - Additional private subnet for database redundancy
- **Internet Gateway**: Provides internet access for resources in public subnet
- **Route Tables**: Separate route tables for public and private subnets
- **Availability Zones**: Multiple AZs for high availability

### Security Configuration
- **Web Server Security Group**:
  - Inbound: HTTP (80), HTTPS (443), SSH (22)
  - Outbound: All traffic
- **Database Security Group**:
  - Inbound: MySQL/PostgreSQL from web server security group only
  - Outbound: Limited traffic

### Database Configuration
- **Engine**: AWS RDS (MySQL/PostgreSQL)
- **Instance Class**: Configurable via variables
- **Storage**: Encrypted EBS volumes
- **Multi-AZ**: Optional configuration for high availability
- **Backup**: Automated backups enabled
- **Credentials**: Managed through Terraform variables

### Web Server Configuration
- **AMI**: Ubuntu 20.04 LTS
- **Instance Type**: Configurable via variables
- **Root Volume**: 10GB GP2 encrypted EBS volume
- **User Data**: Automated setup script for application deployment
- **SSH Access**: Generated key pair for secure access
- **Elastic IP**: Static public IP for reliable access

## Deployment Parameters

| Component | Parameter | Default/Example | Description |
|-----------|-----------|----------------|-------------|
| VPC | CIDR Block | 10.0.0.0/16 | IP range for the VPC |
| Public Subnet | CIDR Block | 10.0.1.0/24 | IP range for public subnet |
| Private Subnet | CIDR Block | 10.0.2.0/24 | IP range for primary private subnet |
| Private Subnet 2 | CIDR Block | 10.0.3.0/24 | IP range for secondary private subnet |
| Web Server | Instance Type | t2.micro | EC2 instance size |
| Web Server | AMI | Ubuntu 20.04 | Operating system |
| Database | Instance Class | db.t3.micro | RDS instance size |
| Database | Engine | MySQL/PostgreSQL | Database engine |
| Database | Storage | 20GB | Allocated storage |

## Scaling Considerations

- **Web Tier**: Can be extended to use Auto Scaling Groups
- **Database Tier**: Can be configured for read replicas or Multi-AZ deployment
- **Network**: Designed with multiple subnets to accommodate growth

## Security Considerations

- **Network Isolation**: Private subnets for sensitive resources
- **Security Groups**: Principle of least privilege
- **SSH Access**: Key-based authentication only
- **Database**: No direct public access
- **Encryption**: EBS volumes encrypted at rest

## Monitoring and Management

- **Logs**: CloudWatch Logs integration possible
- **Metrics**: CloudWatch Metrics for resource utilization
- **Alerts**: Can be extended with CloudWatch Alarms
- **Access**: SSH for web servers, RDS endpoints for databases