#!/bin/bash

###############################################################################
# EC2 Instance Initialization Script
# 
# This script runs on first boot of the EC2 instance
# Installs required software and configures the environment
#
# Instance Type: r6i.4xlarge (128GB RAM)
###############################################################################

set -e

# Logging
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "=========================================="
echo "Starting EC2 Instance Initialization"
echo "Instance Type: r6i.4xlarge (128GB RAM)"
echo "=========================================="

# Update system
echo "Updating system packages..."
yum update -y

# Install Node.js 20.x
echo "Installing Node.js 20.x..."
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
yum install -y nodejs

# Install development tools
echo "Installing development tools..."
yum groupinstall -y "Development Tools"
yum install -y git wget curl vim

# Install nginx
echo "Installing nginx..."
amazon-linux-extras install -y nginx1
systemctl enable nginx

# Install CloudWatch agent
echo "Installing CloudWatch agent..."
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm
rm -f ./amazon-cloudwatch-agent.rpm

# Configure CloudWatch agent
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<'EOF'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/user-data.log",
            "log_group_name": "/geekcon/system",
            "log_stream_name": "{instance_id}/user-data"
          },
          {
            "file_path": "/opt/geekcon/logs/application.log",
            "log_group_name": "/geekcon/application",
            "log_stream_name": "{instance_id}/application"
          },
          {
            "file_path": "/var/log/nginx/access.log",
            "log_group_name": "/geekcon/nginx",
            "log_stream_name": "{instance_id}/access"
          },
          {
            "file_path": "/var/log/nginx/error.log",
            "log_group_name": "/geekcon/nginx",
            "log_stream_name": "{instance_id}/error"
          }
        ]
      }
    }
  },
  "metrics": {
    "namespace": "GeekconHerbs",
    "metrics_collected": {
      "cpu": {
        "measurement": [
          {
            "name": "cpu_usage_idle",
            "rename": "CPU_IDLE",
            "unit": "Percent"
          }
        ],
        "metrics_collection_interval": 60,
        "totalcpu": false
      },
      "disk": {
        "measurement": [
          {
            "name": "used_percent",
            "rename": "DISK_USED",
            "unit": "Percent"
          }
        ],
        "metrics_collection_interval": 60,
        "resources": [
          "*"
        ]
      },
      "mem": {
        "measurement": [
          {
            "name": "mem_used_percent",
            "rename": "MEMORY_USED",
            "unit": "Percent"
          }
        ],
        "metrics_collection_interval": 60
      },
      "netstat": {
        "measurement": [
          {
            "name": "tcp_established",
            "rename": "TCP_CONNECTIONS",
            "unit": "Count"
          }
        ],
        "metrics_collection_interval": 60
      }
    }
  }
}
EOF

# Start CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -s \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# Create application directory
echo "Creating application directory..."
mkdir -p /opt/geekcon
mkdir -p /opt/geekcon/logs
chown -R ec2-user:ec2-user /opt/geekcon

# Configure nginx
echo "Configuring nginx..."
cat > /etc/nginx/conf.d/geekcon.conf <<'EOF'
upstream nextjs {
    server localhost:3000;
}

server {
    listen 80;
    server_name _;

    # Redirect to HTTPS
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name _;

    # SSL certificates (to be configured)
    # ssl_certificate /etc/nginx/ssl/cert.pem;
    # ssl_certificate_key /etc/nginx/ssl/key.pem;

    # SSL configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    # Logging
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css text/xml text/javascript application/json application/javascript application/xml+rss;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;

    # Static files
    location /_next/static {
        alias /opt/geekcon/.next/static;
        expires 365d;
        add_header Cache-Control "public, immutable";
    }

    location /static {
        alias /opt/geekcon/public;
        expires 365d;
        add_header Cache-Control "public, immutable";
    }

    # Next.js application
    location / {
        proxy_pass http://nextjs;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 60s;
    }

    # Health check endpoint
    location /api/health {
        proxy_pass http://nextjs;
        access_log off;
    }
}
EOF

# Restart nginx
systemctl restart nginx

# Create systemd service for Next.js app
echo "Creating systemd service..."
cat > /etc/systemd/system/geekcon.service <<'EOF'
[Unit]
Description=Geekcon Herbs Next.js Application
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/opt/geekcon
Environment="NODE_ENV=production"
Environment="PORT=3000"
ExecStart=/usr/bin/npm start
Restart=on-failure
RestartSec=10
StandardOutput=append:/opt/geekcon/logs/application.log
StandardError=append:/opt/geekcon/logs/application.log

[Install]
WantedBy=multi-user.target
EOF

# Enable service
systemctl enable geekcon.service

# Configure swap (even with 128GB RAM, good practice)
echo "Configuring swap..."
dd if=/dev/zero of=/swapfile bs=1G count=4
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# Optimize system for RAM-intensive operations
echo "Optimizing system parameters..."
cat >> /etc/sysctl.conf <<EOF

# Geekcon Herbs optimizations for r6i.4xlarge (128GB RAM)
vm.swappiness=10
vm.dirty_ratio=15
vm.dirty_background_ratio=5
net.core.somaxconn=1024
net.ipv4.tcp_max_syn_backlog=2048
net.ipv4.tcp_tw_reuse=1
EOF

sysctl -p

# Set up automatic security updates
echo "Configuring automatic security updates..."
yum install -y yum-cron
sed -i 's/update_cmd = default/update_cmd = security/' /etc/yum/yum-cron.conf
sed -i 's/apply_updates = no/apply_updates = yes/' /etc/yum/yum-cron.conf
systemctl enable yum-cron
systemctl start yum-cron

# Install monitoring tools
echo "Installing monitoring tools..."
yum install -y htop iotop sysstat

# Create deployment user
echo "Creating deployment user..."
useradd -m -s /bin/bash deploy
mkdir -p /home/deploy/.ssh
# SSH keys would be added here in production

# Create monitoring script
cat > /usr/local/bin/geekcon-monitor.sh <<'EOF'
#!/bin/bash
# Quick status check script

echo "=== Geekcon Herbs Status ==="
echo ""
echo "Application Service:"
systemctl status geekcon.service --no-pager | head -5
echo ""
echo "Nginx Service:"
systemctl status nginx --no-pager | head -5
echo ""
echo "Memory Usage:"
free -h
echo ""
echo "Disk Usage:"
df -h / /opt/geekcon
echo ""
echo "Recent Application Logs:"
tail -5 /opt/geekcon/logs/application.log
EOF

chmod +x /usr/local/bin/geekcon-monitor.sh

# Create health check script
cat > /usr/local/bin/health-check.sh <<'EOF'
#!/bin/bash
# Health check script for monitoring

response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/health)

if [ "$response" = "200" ]; then
    echo "OK"
    exit 0
else
    echo "FAIL"
    exit 1
fi
EOF

chmod +x /usr/local/bin/health-check.sh

# Schedule health checks
echo "*/5 * * * * /usr/local/bin/health-check.sh >> /var/log/health-check.log 2>&1" | crontab -

# Final setup
echo "Running final setup..."

# Ensure correct permissions
chown -R ec2-user:ec2-user /opt/geekcon

# Send completion signal
echo "=========================================="
echo "EC2 Instance Initialization Complete"
echo "Instance is ready for application deployment"
echo "=========================================="

# Signal CloudFormation (if launched via CFN)
# /opt/aws/bin/cfn-signal -e $? --stack STACK_NAME --resource RESOURCE_NAME --region REGION
