#!/bin/bash
# Geekcon Herbs - Infrastructure Deployment Script
# Following MEOW Principle: Well-documented deployment automation
# AWS Profile: villaai | Region: ap-southeast-1

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
export AWS_PROFILE=villaai
export AWS_REGION=ap-southeast-1
PROJECT_NAME="geekcon-herbs"
KEY_NAME="${PROJECT_NAME}-key"
TERRAFORM_DIR="./terraform"

echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Geekcon Herbs Infrastructure Deployment            ║${NC}"
echo -e "${BLUE}║  MEOW Principle: Modular, Efficient, Observable,    ║${NC}"
echo -e "${BLUE}║                  Well-documented                     ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# Function: Print step
print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

# Function: Print success
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function: Print error
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Function: Print warning
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Step 1: Prerequisites Check
print_step "Step 1: Checking prerequisites..."

# Check AWS CLI
if ! command -v aws &> /dev/null; then
    print_error "AWS CLI not found. Please install AWS CLI first."
    exit 1
fi
print_success "AWS CLI found"

# Check Terraform
if ! command -v terraform &> /dev/null; then
    print_error "Terraform not found. Please install Terraform first."
    exit 1
fi
print_success "Terraform found"

# Check AWS credentials
if ! aws sts get-caller-identity --profile $AWS_PROFILE &> /dev/null; then
    print_error "AWS credentials not configured for profile: $AWS_PROFILE"
    exit 1
fi
print_success "AWS credentials verified for profile: $AWS_PROFILE"

echo ""

# Step 2: Create SSH Key Pair
print_step "Step 2: Creating SSH key pair..."

if aws ec2 describe-key-pairs --key-names $KEY_NAME --profile $AWS_PROFILE --region $AWS_REGION &> /dev/null; then
    print_warning "Key pair '$KEY_NAME' already exists, skipping creation"
else
    aws ec2 create-key-pair \
        --key-name $KEY_NAME \
        --profile $AWS_PROFILE \
        --region $AWS_REGION \
        --query 'KeyMaterial' \
        --output text > ~/.ssh/${KEY_NAME}.pem
    
    chmod 400 ~/.ssh/${KEY_NAME}.pem
    print_success "SSH key pair created: ~/.ssh/${KEY_NAME}.pem"
fi

echo ""

# Step 3: Create Terraform Backend Resources
print_step "Step 3: Setting up Terraform backend..."

# Create S3 bucket for Terraform state
BUCKET_NAME="${PROJECT_NAME}-terraform-state"
if aws s3 ls s3://$BUCKET_NAME --profile $AWS_PROFILE --region $AWS_REGION 2>&1 | grep -q 'NoSuchBucket'; then
    aws s3api create-bucket \
        --bucket $BUCKET_NAME \
        --profile $AWS_PROFILE \
        --region $AWS_REGION \
        --create-bucket-configuration LocationConstraint=$AWS_REGION
    
    aws s3api put-bucket-versioning \
        --bucket $BUCKET_NAME \
        --versioning-configuration Status=Enabled \
        --profile $AWS_PROFILE \
        --region $AWS_REGION
    
    aws s3api put-bucket-encryption \
        --bucket $BUCKET_NAME \
        --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}' \
        --profile $AWS_PROFILE \
        --region $AWS_REGION
    
    print_success "Terraform state bucket created: $BUCKET_NAME"
else
    print_warning "Terraform state bucket already exists: $BUCKET_NAME"
fi

# Create DynamoDB table for Terraform locks
TABLE_NAME="${PROJECT_NAME}-terraform-locks"
if ! aws dynamodb describe-table --table-name $TABLE_NAME --profile $AWS_PROFILE --region $AWS_REGION &> /dev/null; then
    aws dynamodb create-table \
        --table-name $TABLE_NAME \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST \
        --profile $AWS_PROFILE \
        --region $AWS_REGION
    
    print_success "Terraform lock table created: $TABLE_NAME"
else
    print_warning "Terraform lock table already exists: $TABLE_NAME"
fi

echo ""

# Step 4: Initialize Terraform
print_step "Step 4: Initializing Terraform..."

cd $TERRAFORM_DIR

# Comment out backend config for first run since bucket might not exist yet
terraform init -upgrade

print_success "Terraform initialized"

echo ""

# Step 5: Terraform Plan
print_step "Step 5: Creating Terraform execution plan..."

terraform plan -out=tfplan

print_success "Terraform plan created"

echo ""

# Step 6: Confirm Deployment
print_warning "Ready to deploy infrastructure to AWS"
echo -e "${YELLOW}Region: $AWS_REGION${NC}"
echo -e "${YELLOW}Profile: $AWS_PROFILE${NC}"
echo -e "${YELLOW}Instance Type: r6i.4xlarge (128GB RAM)${NC}"
echo ""
read -p "Do you want to proceed with deployment? (yes/no): " -r
echo ""

if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    print_warning "Deployment cancelled by user"
    exit 0
fi

# Step 7: Apply Terraform
print_step "Step 7: Deploying infrastructure (this may take 5-10 minutes)..."

terraform apply tfplan

print_success "Infrastructure deployed successfully!"

echo ""

# Step 8: Get Outputs
print_step "Step 8: Retrieving deployment information..."

INSTANCE_ID=$(terraform output -raw instance_id)
PUBLIC_IP=$(terraform output -raw instance_public_ip)
PRIVATE_IP=$(terraform output -raw instance_private_ip)

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Deployment Complete!                                ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Instance Details:${NC}"
echo -e "  Instance ID:  ${GREEN}$INSTANCE_ID${NC}"
echo -e "  Public IP:    ${GREEN}$PUBLIC_IP${NC}"
echo -e "  Private IP:   ${GREEN}$PRIVATE_IP${NC}"
echo ""
echo -e "${BLUE}SSH Access:${NC}"
echo -e "  ${GREEN}ssh -i ~/.ssh/${KEY_NAME}.pem ec2-user@$PUBLIC_IP${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo -e "  1. Wait 2-3 minutes for instance initialization to complete"
echo -e "  2. SSH into the instance and check initialization logs:"
echo -e "     ${YELLOW}tail -f /var/log/cloud-init-output.log${NC}"
echo -e "  3. Verify services are running:"
echo -e "     ${YELLOW}systemctl status nginx${NC}"
echo -e "     ${YELLOW}systemctl status amazon-cloudwatch-agent${NC}"
echo -e "  4. Check CloudWatch dashboard:"
echo -e "     ${YELLOW}https://console.aws.amazon.com/cloudwatch/home?region=$AWS_REGION#dashboards:name=${PROJECT_NAME}-overview${NC}"
echo ""
echo -e "${BLUE}MEOW Principle Verification:${NC}"
echo -e "  ✓ Modular:        VPC, Security, Compute, Monitoring modules"
echo -e "  ✓ Efficient:      r6i.4xlarge (128GB RAM), gp3 volumes"
echo -e "  ✓ Observable:     CloudWatch logs, metrics, alarms, dashboard"
echo -e "  ✓ Well-documented: Complete Terraform docs and this output"
echo ""

# Create deployment record
cd ..
cat > DEPLOYMENT_RECORD.md << EOF
# Geekcon Herbs - Deployment Record

**Date**: $(date)
**Status**: ✅ DEPLOYED

## Instance Details
- **Instance ID**: $INSTANCE_ID
- **Instance Type**: r6i.4xlarge (128GB RAM, 16 vCPUs)
- **Public IP**: $PUBLIC_IP
- **Private IP**: $PRIVATE_IP
- **Region**: $AWS_REGION
- **SSH Key**: ~/.ssh/${KEY_NAME}.pem

## SSH Access
\`\`\`bash
ssh -i ~/.ssh/${KEY_NAME}.pem ec2-user@$PUBLIC_IP
\`\`\`

## MEOW Principle Implementation
- ✅ **Modular**: Separated modules (network, security, compute, monitoring)
- ✅ **Efficient**: RAM-optimized EC2 (128GB), gp3 volumes (3000 IOPS)
- ✅ **Observable**: CloudWatch logs, metrics, alarms, dashboard
- ✅ **Well-documented**: Complete Terraform configuration and documentation

## Resources Created
- VPC with 2 public and 2 private subnets across 2 AZs
- Internet Gateway and 2 NAT Gateways (high availability)
- Security groups with least privilege access
- EC2 r6i.4xlarge instance with Elastic IP
- 500GB gp3 application data volume
- IAM roles with DynamoDB, S3, Secrets Manager access
- CloudWatch log groups, alarms, and dashboard
- Existing DynamoDB tables and S3 buckets (from previous deployment)

## Next Steps
1. Wait for instance initialization (2-3 minutes)
2. SSH into instance and verify services
3. Deploy Geekcon Herbs application
4. Run Playwright test suite
5. Configure domain and SSL certificate
EOF

print_success "Deployment record saved to DEPLOYMENT_RECORD.md"

echo ""
print_success "All done! 🎉"
