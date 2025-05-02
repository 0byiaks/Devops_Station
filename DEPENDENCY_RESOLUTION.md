# Dependency Resolution for Subnet Deletion Error

## Problem

The following error was encountered during `terraform apply`:

```
Error: deleting EC2 Subnet (subnet-0391b6ba0c4e3beaf): DependencyViolation: The subnet 'subnet-0391b6ba0c4e3beaf' has dependencies and cannot be deleted.
status code: 400, request id: fc672875-c842-40ac-b9ed-2b2197dfaabb
```

This error occurs when Terraform attempts to delete a subnet that still has resources dependent on it. In AWS, you cannot delete a subnet that has resources like EC2 instances, RDS instances, or other AWS resources still using it.

## Root Cause

The issue was caused by improper dependency management in the Terraform configuration. When Terraform tried to destroy or modify resources, it attempted to delete the subnet before destroying the resources that depend on it, specifically:

1. The RDS instance in the database module was using the private subnets through a DB subnet group
2. The EC2 instance in the webserver module was using the public subnet

## Solution

The solution involved adding proper lifecycle configurations to ensure resources are created and destroyed in the correct order:

### 1. Database Module Changes

- Added `lifecycle { create_before_destroy = true }` to the DB subnet group
- Added `lifecycle { create_before_destroy = true }` to the RDS parameter group
- Added `lifecycle { create_before_destroy = true }` to the RDS instance
- Added explicit `depends_on` to the RDS instance to ensure it depends on the DB subnet group

### 2. Network Module Changes

- Added `lifecycle { create_before_destroy = true }` to all subnet resources to ensure they're not destroyed while resources are still using them

### 3. Webserver Module Changes

- Added `lifecycle { create_before_destroy = true }` to the EC2 instance
- Added `lifecycle { create_before_destroy = true }` to the Elastic IP

## How It Works

The `create_before_destroy = true` lifecycle configuration tells Terraform to:

1. Create a new resource before destroying the old one when a resource needs to be replaced
2. Ensure proper dependency ordering during resource destruction

This ensures that when resources are being destroyed:
- The EC2 instance and RDS instance are destroyed before their associated subnets
- The DB subnet group is destroyed before the private subnets
- The Elastic IP is destroyed before the EC2 instance

## Testing

To verify the fix:

1. Run `terraform apply` to apply any pending changes
2. Run `terraform destroy -target=module.network.aws_subnet.private` to test if a subnet can be destroyed properly
3. Run `terraform apply` to recreate the destroyed resources

## Best Practices

1. Always use proper lifecycle configurations for resources with dependencies
2. Use explicit `depends_on` attributes when implicit dependencies aren't sufficient
3. Consider the destruction order when designing Terraform modules
4. Test resource destruction with `-target` flag before applying changes to production