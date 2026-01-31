# Geekcon Herbs Deployment Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Infrastructure Setup](#infrastructure-setup)
3. [Application Deployment](#application-deployment)
4. [Testing & Validation](#testing--validation)
5. [Monitoring](#monitoring)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software
- **AWS CLI** (configured with `villaai` profile)
- **Node.js** >= 20.0.0
- **npm** >= 10.0.0
- **Git**
- **Gastown** (infrastructure automation tool)

### AWS Resources Required
- VPC with public and private subnets
- EC2 instance (r6i.4xlarge - 128GB RAM)
- Application Load Balancer
- S3 buckets for assets and backups
- DynamoDB tables
- CloudWatch for logging and monitoring
- Route53 (for DNS)
- ACM certificate (for HTTPS)

### Environment Variables
```bash
export AWS_PROFILE=villaai
export AWS_REGION=us-west-2
export ENVIRONMENT=production
```

---

## Infrastructure Setup

### Step 1: Review Configuration
Review the Gastown configuration file:
```bash
cat gastown-config.yml
```

Verify:
- Instance type (r6i.4xlarge with 128GB RAM)
- VPC CIDR blocks
- Security group rules
- DynamoDB table names
- S3 bucket names

### Step 2: Initialize Infrastructure
```bash
# Validate configuration
gastown validate --config gastown-config.yml

# Create infrastructure (dry run first)
gastown apply --config gastown-config.yml --dry-run

# Apply infrastructure
gastown apply --config gastown-config.yml --profile villaai
```

This will create:
- VPC and networking components
- EC2 instance with initialization script
- Load balancer and target groups
- S3 buckets
- DynamoDB tables
- CloudWatch log groups
- IAM roles and policies

### Step 3: Verify Infrastructure
```bash
# Check EC2 instance
aws ec2 describe-instances \
  --filters "Name=tag:Project,Values=geekcon-herbs" \
  --profile villaai

# Check load balancer
aws elbv2 describe-load-balancers \
  --names geekcon-herbs-alb \
  --profile villaai

# Verify DynamoDB tables
aws dynamodb list-tables --profile villaai
```

---

## Application Deployment

### Step 1: Prepare Local Environment
```bash
# Clone repository
git clone <repository-url>
cd geekcon-site-demo

# Run setup script
./scripts/setup.sh
```

### Step 2: Build Application
```bash
# Install dependencies
npm ci

# Run quality checks
npm run lint
npm run type-check
npm run test

# Build application
npm run build
```

### Step 3: Deploy to AWS
```bash
# Deploy using Gastown script
./scripts/deploy.sh

# Or manual deployment
export AWS_PROFILE=villaai
export ENVIRONMENT=production

# The script will:
# 1. Validate code
# 2. Build application
# 3. Create deployment package
# 4. Upload to S3
# 5. Deploy to EC2
# 6. Run health checks
```

### Step 4: Configure DNS
```bash
# Get load balancer DNS
LB_DNS=$(aws elbv2 describe-load-balancers \
  --names geekcon-herbs-alb \
  --query 'LoadBalancers[0].DNSName' \
  --output text \
  --profile villaai)

# Create Route53 record (if not using Gastown)
aws route53 change-resource-record-sets \
  --hosted-zone-id <ZONE_ID> \
  --change-batch '{
    "Changes": [{
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "geekconherbs.com",
        "Type": "A",
        "AliasTarget": {
          "HostedZoneId": "<LB_ZONE_ID>",
          "DNSName": "'$LB_DNS'",
          "EvaluateTargetHealth": true
        }
      }
    }]
  }' \
  --profile villaai
```

---

## Testing & Validation

### Step 1: Smoke Tests
```bash
# Test application health
curl https://geekconherbs.com/api/health

# Expected response: {"status":"ok"}
```

### Step 2: Run Playwright Tests
```bash
# Set test URL
export TEST_URL=https://geekconherbs.com

# Run full test suite
./scripts/run-tests.sh

# Or run specific suites
npm run test:e2e -- tests/playwright/visual-regression.spec.ts
npm run test:e2e -- tests/playwright/accessibility.spec.ts
npm run test:e2e -- tests/playwright/performance.spec.ts
```

### Step 3: Performance Validation
Check Core Web Vitals:
```bash
# Run Lighthouse
npx lighthouse https://geekconherbs.com \
  --output=html \
  --output-path=./lighthouse-report.html

# View report
open lighthouse-report.html
```

Target metrics (from DESIGN_DOCUMENT.md):
- LCP: < 2.5s
- FID: < 100ms
- CLS: < 0.1

---

## Monitoring

### CloudWatch Dashboards

Access dashboards:
```bash
# Get dashboard URL
aws cloudwatch get-dashboard \
  --dashboard-name geekcon-overview \
  --profile villaai
```

Or navigate to:
https://console.aws.amazon.com/cloudwatch/home?region=us-west-2#dashboards:

### Key Metrics to Monitor

1. **Application Metrics**
   - Request count
   - Error rate
   - Response time (p50, p95, p99)
   - Active users

2. **Infrastructure Metrics**
   - CPU utilization
   - Memory utilization
   - Disk usage
   - Network throughput

3. **Business Metrics**
   - Conversion rate
   - Cart abandonment
   - Product views
   - Revenue

### Logs

View logs:
```bash
# Application logs
aws logs tail /geekcon/application --follow --profile villaai

# Nginx logs
aws logs tail /geekcon/nginx --follow --profile villaai

# System logs
aws logs tail /geekcon/system --follow --profile villaai
```

### Alarms

Configure alarms for:
- High error rate (>5%)
- High response time (>3s)
- High CPU (>80%)
- High memory (>85%)
- Disk space low (<20% free)

---

## Troubleshooting

### Common Issues

#### 1. Application Not Starting
```bash
# SSH to EC2 instance
aws ssm start-session --target <instance-id> --profile villaai

# Check service status
sudo systemctl status geekcon

# View logs
sudo tail -f /opt/geekcon/logs/application.log

# Restart service
sudo systemctl restart geekcon
```

#### 2. High Memory Usage
```bash
# Connect to instance
aws ssm start-session --target <instance-id> --profile villaai

# Check memory
free -h
htop

# Check Node.js process
ps aux | grep node

# If needed, restart application
sudo systemctl restart geekcon
```

#### 3. Database Connection Issues
```bash
# Check DynamoDB table status
aws dynamodb describe-table \
  --table-name geekcon-products \
  --profile villaai

# Verify IAM role permissions
aws iam get-role \
  --role-name geekcon-ec2-role \
  --profile villaai
```

#### 4. Load Balancer Health Checks Failing
```bash
# Check target health
aws elbv2 describe-target-health \
  --target-group-arn <target-group-arn> \
  --profile villaai

# Test health endpoint locally
curl http://localhost:3000/api/health

# Check security group rules
aws ec2 describe-security-groups \
  --filters "Name=tag:Name,Values=geekcon-web-sg" \
  --profile villaai
```

#### 5. Slow Performance
1. Check CloudWatch metrics
2. Review Playwright performance tests
3. Analyze bundle size
4. Check database query performance
5. Review cache hit rates

### Emergency Procedures

#### Rollback Deployment
```bash
# Stop current version
sudo systemctl stop geekcon

# Restore previous version from backup
aws s3 cp s3://geekcon-herbs-backups/previous-version.tar.gz /opt/geekcon/
cd /opt/geekcon
tar -xzf previous-version.tar.gz

# Restart service
sudo systemctl start geekcon

# Verify health
curl http://localhost:3000/api/health
```

#### Scale Up Resources
```bash
# If experiencing high load, consider:
# 1. Enable auto-scaling (if configured)
# 2. Manually launch additional instances
# 3. Increase instance size (requires stop/start)

# Stop instance
aws ec2 stop-instances --instance-ids <instance-id> --profile villaai

# Modify instance type (if needed)
aws ec2 modify-instance-attribute \
  --instance-id <instance-id> \
  --instance-type '{"Value": "r6i.8xlarge"}' \
  --profile villaai

# Start instance
aws ec2 start-instances --instance-ids <instance-id> --profile villaai
```

---

## Maintenance

### Regular Tasks

#### Daily
- Review CloudWatch dashboards
- Check error logs
- Monitor performance metrics
- Verify backups

#### Weekly
- Review security updates
- Analyze user behavior metrics
- Check cost reports
- Review Playwright test results

#### Monthly
- Update dependencies
- Review and optimize database
- Review and update documentation
- Conduct security audit
- Review and optimize costs

### Updates

#### Application Updates
```bash
# Pull latest code
git pull origin main

# Run tests
npm run test
npm run test:e2e

# Build and deploy
./scripts/deploy.sh
```

#### System Updates
```bash
# Connect to instance
aws ssm start-session --target <instance-id> --profile villaai

# Check for updates
sudo yum check-update

# Apply security updates (automatic via yum-cron)
# Or manually:
sudo yum update -y --security
```

---

## Support Contacts

- **Technical Lead**: [Contact Info]
- **DevOps Team**: [Contact Info]
- **AWS Support**: [Support Plan Details]
- **Emergency Hotline**: [Phone Number]

---

## Additional Resources

- [DESIGN_DOCUMENT.md](./DESIGN_DOCUMENT.md) - UI/UX specifications
- [MEOW_WORKFLOW.md](./MEOW_WORKFLOW.md) - Development workflow
- [gastown-config.yml](./gastown-config.yml) - Infrastructure configuration
- [AWS Best Practices](https://aws.amazon.com/architecture/well-architected/)
- [Next.js Deployment Docs](https://nextjs.org/docs/deployment)

---

**Last Updated**: January 31, 2026  
**Version**: 1.0  
**Maintained By**: Gastown Infrastructure Team
