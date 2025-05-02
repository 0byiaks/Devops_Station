#!/bin/bash

# Script to connect to the EC2 instance

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "Error: terraform is not installed or not in PATH"
    exit 1
fi

# Get the SSH command from terraform output
SSH_COMMAND=$(terraform output -raw ssh_connection_command)

if [ $? -ne 0 ]; then
    echo "Error: Failed to get SSH command from terraform output"
    echo "Make sure you have applied the terraform configuration first with 'terraform apply'"
    exit 1
fi

echo "Connecting to EC2 instance using command: $SSH_COMMAND"
echo "Press Ctrl+C to cancel or any other key to continue..."
read -n 1 -s

# Execute the SSH command
eval $SSH_COMMAND

# Check if SSH connection was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to connect to the EC2 instance"
    echo "Possible reasons:"
    echo "  - The instance might not be running"
    echo "  - Security group might not allow SSH access"
    echo "  - The private key file (web_key.pem) might not have correct permissions"
    echo ""
    echo "Try manually with: $SSH_COMMAND"
    exit 1
fi