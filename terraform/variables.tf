# Geekcon Herbs - Terraform Variables
# MEOW Principle: Well-documented variable definitions

variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_profile" {
  description = "AWS CLI Profile"
  type        = string
  default     = "villaai"
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "geekcon-herbs"
}

variable "environment" {
  description = "Environment (production, staging, dev)"
  type        = string
  default     = "production"
}

# Network Configuration - MEOW: Modular
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

# Compute Configuration - MEOW: Efficient (128GB RAM)
variable "instance_type" {
  description = "EC2 instance type - RAM-optimized"
  type        = string
  default     = "r6i.4xlarge"  # 128GB RAM, 16 vCPUs
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "geekcon-herbs-key"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 100
}

variable "app_volume_size" {
  description = "Application volume size in GB"
  type        = number
  default     = 500
}

# Security Configuration
variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # TODO: Restrict to specific IPs
}

# Monitoring Configuration - MEOW: Observable
variable "cpu_alarm_threshold" {
  description = "CPU utilization alarm threshold (%)"
  type        = number
  default     = 80
}

variable "memory_alarm_threshold" {
  description = "Memory utilization alarm threshold (%)"
  type        = number
  default     = 85
}

variable "disk_alarm_threshold" {
  description = "Disk utilization alarm threshold (%)"
  type        = number
  default     = 80
}

variable "alarm_actions" {
  description = "SNS topic ARNs for alarm notifications"
  type        = list(string)
  default     = []
}

# Tags - MEOW: Well-documented
variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "geekcon-herbs"
    Environment = "production"
    ManagedBy   = "gastown"
    Principle   = "MEOW"
    Owner       = "villaai"
  }
}
