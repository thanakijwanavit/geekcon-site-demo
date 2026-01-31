# Security Module - MEOW: Efficient (Least privilege)
# Security Groups, IAM Roles, Instance Profile

# Web Security Group
resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for Geekcon web application"
  vpc_id      = var.vpc_id
  
  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS traffic"
  }
  
  # HTTP (redirect to HTTPS)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP traffic"
  }
  
  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
    description = "SSH access"
  }
  
  # All outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }
  
  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

# IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"
  
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
    Name = "${var.project_name}-ec2-role"
  }
}

# CloudWatch Agent Policy
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# SSM Managed Instance Core Policy
resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# DynamoDB Access Policy
resource "aws_iam_policy" "dynamodb_access" {
  name        = "${var.project_name}-dynamodb-access"
  description = "DynamoDB access for Geekcon application"
  
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
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem"
        ]
        Resource = [
          "arn:aws:dynamodb:*:*:table/geekcon-products",
          "arn:aws:dynamodb:*:*:table/geekcon-users",
          "arn:aws:dynamodb:*:*:table/geekcon-orders",
          "arn:aws:dynamodb:*:*:table/geekcon-orders/index/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}

# S3 Access Policy
resource "aws_iam_policy" "s3_access" {
  name        = "${var.project_name}-s3-access"
  description = "S3 access for Geekcon assets and backups"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::geekcon-herbs-assets-*",
          "arn:aws:s3:::geekcon-herbs-assets-*/*",
          "arn:aws:s3:::geekcon-herbs-backups-*",
          "arn:aws:s3:::geekcon-herbs-backups-*/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}

# Secrets Manager Access Policy
resource "aws_iam_policy" "secrets_access" {
  name        = "${var.project_name}-secrets-access"
  description = "Secrets Manager access for application secrets"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "arn:aws:secretsmanager:*:*:secret:geekcon/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.secrets_access.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# Outputs
output "web_security_group_id" {
  value = aws_security_group.web.id
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "ec2_role_arn" {
  value = aws_iam_role.ec2_role.arn
}
