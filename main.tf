


  
  # Uncomment this block to use S3 backend
  # backend "s3" {
  #   bucket         = "infra-c-terraform-state"
  #   key            = "terraform-aws-project/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  # }



# Network Module
module "network" {
  source = "./modules/network"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  private_subnet_2_cidr = "10.0.3.0/24"
  availability_zone  = var.availability_zone
  additional_az      = var.additional_az
  environment        = var.environment
}

# Security Module
module "security" {
  source = "./modules/security"

  vpc_id      = module.network.vpc_id
  environment = var.environment
}

# Database Module
module "database" {
  source = "./modules/database"
  vpc_id      = module.network.vpc_id
  environment        = var.environment
  private_subnet_id  = module.network.private_subnet_id
  private_subnet_2_id = module.network.private_subnet_2_id
  db_sg_id           = module.security.db_sg_id
  db_instance_class  = var.db_instance_class
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
}

# Webserver Module
module "webserver" {
  source = "./modules/webserver"

  environment        = var.environment
  instance_type      = var.instance_type
  public_subnet_id   = module.network.public_subnet_id
  web_sg_id          = module.security.web_sg_id
  db_instance_address = module.database.db_instance_address
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password

  depends_on = [module.database]
}