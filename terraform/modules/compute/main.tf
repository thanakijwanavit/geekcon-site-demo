# Compute Module - MEOW: Efficient (RAM-optimized 128GB)
# EC2 Instance with optimized configuration

# Get latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# EC2 Instance - r6i.4xlarge (128GB RAM, 16 vCPUs)
resource "aws_instance" "main" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  key_name              = var.key_name
  subnet_id             = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  
  # MEOW: Efficient - Optimized root volume
  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    iops                 = var.root_volume_iops
    throughput           = 125
    encrypted            = true
    delete_on_termination = false
    
    tags = {
      Name = "${var.project_name}-root-volume"
    }
  }
  
  # MEOW: Well-documented - User data for initialization
  user_data = var.user_data
  
  # Enable detailed monitoring
  monitoring = true
  
  # Metadata options for security
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"  # IMDSv2
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
  
  tags = {
    Name        = "${var.project_name}-web-server"
    Environment = var.environment
    Purpose     = "Web Application Server"
    RAM         = "128GB"
    Principle   = "MEOW"
  }
  
  lifecycle {
    ignore_changes = [ami]
  }
}

# Application Data Volume - 500GB gp3
resource "aws_ebs_volume" "app_data" {
  availability_zone = aws_instance.main.availability_zone
  size              = 500
  type              = "gp3"
  iops              = 3000
  throughput        = 125
  encrypted         = true
  
  tags = {
    Name = "${var.project_name}-app-data-volume"
  }
}

# Attach application data volume
resource "aws_volume_attachment" "app_data" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.app_data.id
  instance_id = aws_instance.main.id
}

# Elastic IP for consistent public IP
resource "aws_eip" "main" {
  instance = aws_instance.main.id
  domain   = "vpc"
  
  tags = {
    Name = "${var.project_name}-eip"
  }
}

# Outputs
output "instance_id" {
  value = aws_instance.main.id
}

output "public_ip" {
  value = aws_eip.main.public_ip
}

output "private_ip" {
  value = aws_instance.main.private_ip
}

output "availability_zone" {
  value = aws_instance.main.availability_zone
}
