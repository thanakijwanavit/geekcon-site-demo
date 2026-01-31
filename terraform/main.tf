# Geekcon Herbs - Main Terraform Configuration
# Following MEOW Principle: Modular, Efficient, Observable, Well-documented
# Gastown Deployment with villaai AWS Profile

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  # MEOW: Well-documented - State management
  backend "s3" {
    bucket         = "geekcon-herbs-terraform-state"
    key            = "infrastructure/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "geekcon-terraform-locks"
  }
}

# Provider Configuration
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  
  default_tags {
    tags = var.common_tags
  }
}

# MEOW Principle: Modular - Each component in separate files
module "network" {
  source = "./modules/network"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  
  # MEOW: Efficient - Multi-AZ for high availability
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security" {
  source = "./modules/security"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.network.vpc_id
  
  # MEOW: Efficient - Least privilege security
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
}

module "compute" {
  source = "./modules/compute"
  
  project_name = var.project_name
  environment  = var.environment
  
  # MEOW: Efficient - RAM-optimized instance (128GB)
  instance_type        = var.instance_type
  key_name            = var.key_name
  subnet_id           = module.network.public_subnet_ids[0]
  security_group_ids  = [module.security.web_security_group_id]
  iam_instance_profile = module.security.instance_profile_name
  
  # MEOW: Well-documented - User data script
  user_data = file("${path.module}/../scripts/init-instance.sh")
  
  # MEOW: Efficient - Optimized storage
  root_volume_size = var.root_volume_size
  root_volume_type = "gp3"
  root_volume_iops = 3000
  
  depends_on = [module.network, module.security]
}

module "monitoring" {
  source = "./modules/monitoring"
  
  project_name = var.project_name
  environment  = var.environment
  
  # MEOW: Observable - CloudWatch integration
  instance_id = module.compute.instance_id
  
  # MEOW: Observable - Alert thresholds
  cpu_alarm_threshold    = var.cpu_alarm_threshold
  memory_alarm_threshold = var.memory_alarm_threshold
  disk_alarm_threshold   = var.disk_alarm_threshold
  
  alarm_actions = var.alarm_actions
  
  depends_on = [module.compute]
}

# Outputs for easy access
output "instance_id" {
  description = "EC2 Instance ID"
  value       = module.compute.instance_id
}

output "instance_public_ip" {
  description = "EC2 Instance Public IP"
  value       = module.compute.public_ip
}

output "instance_private_ip" {
  description = "EC2 Instance Private IP"
  value       = module.compute.private_ip
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "ssh_command" {
  description = "SSH command to connect"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${module.compute.public_ip}"
}
