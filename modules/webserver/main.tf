# Webserver module - main.tf

# Get the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create key-pair for web server
resource "aws_key_pair" "web_key" {
  key_name   = "my-key-pair"
  public_key = tls_private_key.web_key.public_key_openssh
}

resource "tls_private_key" "web_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create EC2 instance for web server
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.web_sg_id]
  key_name               = aws_key_pair.web_key.key_name

  user_data = templatefile("${path.module}/user_data.tpl", {
    environment = var.environment,
    db_address  = var.db_instance_address,
    db_username = var.db_username,
    db_password = var.db_password,
    db_name     = var.db_name
  })

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
    encrypted   = true

    tags = {
      Name = "${var.environment}-web-server-volume"
    }
  }

  tags = {
    Name = "${var.environment}-web-server"
  }

  # This ensures the EC2 instance is destroyed before the subnet
  lifecycle {
    create_before_destroy = true
  }
}

# Create Elastic IP for web server
resource "aws_eip" "web" {
  instance = aws_instance.web.id

  tags = {
    Name = "${var.environment}-web-eip"
  }

  # This ensures the EIP is destroyed before the EC2 instance
  lifecycle {
    create_before_destroy = true
  }
}

# Save private key to file
resource "local_file" "private_key" {
  content  = tls_private_key.web_key.private_key_pem
  filename = "${path.root}/web_key.pem"
  file_permission = "0600"
}