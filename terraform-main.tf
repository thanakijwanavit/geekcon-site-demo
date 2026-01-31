# Geekcon Herbs Infrastructure - Terraform Implementation
# AWS Account: 914499832220
# Profile: villaai
# Region: ap-southeast-1

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = "villaai"
  
  default_tags {
    tags = {
      Project     = "geekcon-herbs"
      Environment = "production"
      ManagedBy   = "gastown"
      Owner       = "villaai"
      Principle   = "MEOW"
    }
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "geekcon-herbs-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "geekcon-herbs-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "geekcon-herbs-public-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "geekcon-herbs-public-2"
  }
}

# Private Subnets
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "geekcon-herbs-private-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "geekcon-herbs-private-2"
  }
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "geekcon-herbs-public-rt"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Security Group for Web Tier
resource "aws_security_group" "web" {
  name        = "geekcon-herbs-web-sg"
  description = "Security group for Geekcon Herbs web application"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "geekcon-herbs-web-sg"
  }
}

# DynamoDB Tables
resource "aws_dynamodb_table" "products" {
  name           = "geekcon-products"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "productId"
  range_key      = "version"

  attribute {
    name = "productId"
    type = "S"
  }

  attribute {
    name = "version"
    type = "N"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "geekcon-products"
  }
}

resource "aws_dynamodb_table" "users" {
  name         = "geekcon-users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"

  attribute {
    name = "userId"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "geekcon-users"
  }
}

resource "aws_dynamodb_table" "orders" {
  name         = "geekcon-orders"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "orderId"
  range_key    = "createdAt"

  attribute {
    name = "orderId"
    type = "S"
  }

  attribute {
    name = "createdAt"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

  global_secondary_index {
    name            = "UserOrdersIndex"
    hash_key        = "userId"
    range_key       = "createdAt"
    projection_type = "ALL"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "geekcon-orders"
  }
}

# S3 Buckets
resource "aws_s3_bucket" "assets" {
  bucket = "geekcon-herbs-assets-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "geekcon-herbs-assets"
  }
}

resource "aws_s3_bucket_versioning" "assets" {
  bucket = aws_s3_bucket.assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "backups" {
  bucket = "geekcon-herbs-backups-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "geekcon-herbs-backups"
  }
}

resource "aws_s3_bucket_versioning" "backups" {
  bucket = aws_s3_bucket.backups.id

  versioning_configuration {
    status = "Enabled"
  }
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "application" {
  name              = "/geekcon/application"
  retention_in_days = 30

  tags = {
    Name = "geekcon-application-logs"
  }
}

resource "aws_cloudwatch_log_group" "nginx" {
  name              = "/geekcon/nginx"
  retention_in_days = 7

  tags = {
    Name = "geekcon-nginx-logs"
  }
}

resource "aws_cloudwatch_log_group" "system" {
  name              = "/geekcon/system"
  retention_in_days = 14

  tags = {
    Name = "geekcon-system-logs"
  }
}

# IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "geekcon-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "geekcon-ec2-role"
  }
}

# IAM Policies
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy" "dynamodb" {
  name = "geekcon-dynamodb-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          aws_dynamodb_table.products.arn,
          aws_dynamodb_table.users.arn,
          aws_dynamodb_table.orders.arn,
          "${aws_dynamodb_table.orders.arn}/index/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3" {
  name = "geekcon-s3-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.assets.arn,
          "${aws_s3_bucket.assets.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2" {
  name = "geekcon-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# Data source
data "aws_caller_identity" "current" {}

# Outputs
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "security_group_id" {
  value = aws_security_group.web.id
}

output "dynamodb_tables" {
  value = {
    products = aws_dynamodb_table.products.name
    users    = aws_dynamodb_table.users.name
    orders   = aws_dynamodb_table.orders.name
  }
}

output "s3_buckets" {
  value = {
    assets  = aws_s3_bucket.assets.bucket
    backups = aws_s3_bucket.backups.bucket
  }
}

output "iam_instance_profile" {
  value = aws_iam_instance_profile.ec2.name
}
