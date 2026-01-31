#!/bin/bash
# Geekcon Herbs - Direct AWS CLI Deployment
# Following MEOW Principle + Gastown Best Practices
# AWS Profile: villaai | Region: ap-southeast-1

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
export AWS_PROFILE=villaai
export AWS_REGION=ap-southeast-1
PROJECT_NAME="geekcon-herbs"
KEY_NAME="${PROJECT_NAME}-key"
INSTANCE_TYPE="r6i.4xlarge"  # 128GB RAM

echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Geekcon Herbs - MEOW Principle Deployment          ║${NC}"
echo -e "${BLUE}║  Modular | Efficient | Observable | Well-documented ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

print_step() { echo -e "${BLUE}▶ $1${NC}"; }
print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }

# Prerequisites
print_step "Checking prerequisites..."
if ! aws sts get-caller-identity --profile $AWS_PROFILE &> /dev/null; then
    print_error "AWS credentials not configured"
    exit 1
fi
print_success "AWS credentials verified"
echo ""

# Create SSH Key
print_step "Creating SSH key pair..."
if aws ec2 describe-key-pairs --key-names $KEY_NAME --profile $AWS_PROFILE --region $AWS_REGION &> /dev/null; then
    print_warning "Key pair already exists"
else
    aws ec2 create-key-pair \
        --key-name $KEY_NAME \
        --profile $AWS_PROFILE \
        --region $AWS_REGION \
        --query 'KeyMaterial' \
        --output text > ~/.ssh/${KEY_NAME}.pem
    chmod 400 ~/.ssh/${KEY_NAME}.pem
    print_success "SSH key created: ~/.ssh/${KEY_NAME}.pem"
fi
echo ""

# Get Default VPC
print_step "Getting default VPC..."
VPC_ID=$(aws ec2 describe-vpcs \
    --filters "Name=is-default,Values=true" \
    --query 'Vpcs[0].VpcId' \
    --output text \
    --profile $AWS_PROFILE \
    --region $AWS_REGION)

if [ "$VPC_ID" == "None" ] || [ -z "$VPC_ID" ]; then
    print_error "No default VPC found. Creating new VPC..."
    # TODO: Create custom VPC
    exit 1
fi
print_success "Using VPC: $VPC_ID"

# Get Subnet
SUBNET_ID=$(aws ec2 describe-subnets \
    --filters "Name=vpc-id,Values=$VPC_ID" "Name=default-for-az,Values=true" \
    --query 'Subnets[0].SubnetId' \
    --output text \
    --profile $AWS_PROFILE \
    --region $AWS_REGION)
print_success "Using Subnet: $SUBNET_ID"
echo ""

# Create Security Group
print_step "Creating security group..."
SG_NAME="${PROJECT_NAME}-web-sg"
SG_ID=$(aws ec2 describe-security-groups \
    --filters "Name=group-name,Values=$SG_NAME" "Name=vpc-id,Values=$VPC_ID" \
    --query 'SecurityGroups[0].GroupId' \
    --output text \
    --profile $AWS_PROFILE \
    --region $AWS_REGION 2>/dev/null || echo "None")

if [ "$SG_ID" == "None" ] || [ -z "$SG_ID" ]; then
    SG_ID=$(aws ec2 create-security-group \
        --group-name $SG_NAME \
        --description "Geekcon Herbs web application security group" \
        --vpc-id $VPC_ID \
        --profile $AWS_PROFILE \
        --region $AWS_REGION \
        --query 'GroupId' \
        --output text)
    
    # Add rules
    aws ec2 authorize-security-group-ingress \
        --group-id $SG_ID \
        --ip-permissions '[{"IpProtocol":"tcp","FromPort":22,"ToPort":22,"IpRanges":[{"CidrIp":"0.0.0.0/0"}]},{"IpProtocol":"tcp","FromPort":80,"ToPort":80,"IpRanges":[{"CidrIp":"0.0.0.0/0"}]},{"IpProtocol":"tcp","FromPort":443,"ToPort":443,"IpRanges":[{"CidrIp":"0.0.0.0/0"}]}]' \
        --profile $AWS_PROFILE --region $AWS_REGION
    
    print_success "Security group created: $SG_ID"
else
    print_warning "Security group already exists: $SG_ID"
fi
echo ""

# Get latest Amazon Linux 2023 AMI
print_step "Finding latest Amazon Linux 2023 AMI..."
AMI_ID=$(aws ec2 describe-images \
    --owners amazon \
    --filters "Name=name,Values=al2023-ami-*-x86_64" \
              "Name=state,Values=available" \
    --query 'sort_by(Images, &CreationDate)[-1].ImageId' \
    --output text \
    --profile $AWS_PROFILE \
    --region $AWS_REGION)
print_success "AMI: $AMI_ID"
echo ""

# Create IAM Role (if not exists)
print_step "Creating IAM instance role..."
ROLE_NAME="${PROJECT_NAME}-ec2-role"
if ! aws iam get-role --role-name $ROLE_NAME --profile $AWS_PROFILE &> /dev/null; then
    aws iam create-role \
        --role-name $ROLE_NAME \
        --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}' \
        --profile $AWS_PROFILE
    
    # Attach policies
    aws iam attach-role-policy \
        --role-name $ROLE_NAME \
        --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy \
        --profile $AWS_PROFILE
    
    aws iam attach-role-policy \
        --role-name $ROLE_NAME \
        --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore \
        --profile $AWS_PROFILE
    
    print_success "IAM role created"
else
    print_warning "IAM role already exists"
fi

# Create instance profile
PROFILE_NAME="${PROJECT_NAME}-ec2-profile"
if ! aws iam get-instance-profile --instance-profile-name $PROFILE_NAME --profile $AWS_PROFILE &> /dev/null; then
    aws iam create-instance-profile \
        --instance-profile-name $PROFILE_NAME \
        --profile $AWS_PROFILE
    
    sleep 2
    
    aws iam add-role-to-instance-profile \
        --instance-profile-name $PROFILE_NAME \
        --role-name $ROLE_NAME \
        --profile $AWS_PROFILE
    
    print_success "Instance profile created"
    sleep 10  # Wait for IAM propagation
else
    print_warning "Instance profile already exists"
fi
echo ""

# Confirmation
print_warning "Ready to deploy EC2 instance"
echo -e "${YELLOW}Instance Type: $INSTANCE_TYPE (128GB RAM, 16 vCPUs)${NC}"
echo -e "${YELLOW}Region: $AWS_REGION${NC}"
echo -e "${YELLOW}Estimated cost: Approximately \$2.50/hour${NC}"
echo ""
read -p "Proceed with deployment? (yes/no): " -r
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    print_warning "Deployment cancelled"
    exit 0
fi
echo ""

# Launch EC2 Instance
print_step "Launching EC2 instance (this will take 2-3 minutes)..."

INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SG_ID \
    --subnet-id $SUBNET_ID \
    --iam-instance-profile Name=$PROFILE_NAME \
    --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":100,"VolumeType":"gp3","Iops":3000,"DeleteOnTermination":false,"Encrypted":true}}]' \
    --user-data file://scripts/init-instance.sh \
    --monitoring Enabled=true \
    --metadata-options HttpTokens=required,HttpPutResponseHopLimit=1 \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${PROJECT_NAME}-web},{Key=Project,Value=$PROJECT_NAME},{Key=Principle,Value=MEOW},{Key=RAM,Value=128GB}]" \
    --profile $AWS_PROFILE \
    --region $AWS_REGION \
    --query 'Instances[0].InstanceId' \
    --output text)

print_success "Instance launched: $INSTANCE_ID"
echo ""

# Wait for instance to be running
print_step "Waiting for instance to be running..."
aws ec2 wait instance-running \
    --instance-ids $INSTANCE_ID \
    --profile $AWS_PROFILE \
    --region $AWS_REGION

print_success "Instance is running!"
echo ""

# Get Public IP
print_step "Getting public IP address..."
PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text \
    --profile $AWS_PROFILE \
    --region $AWS_REGION)

PRIVATE_IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query 'Reservations[0].Instances[0].PrivateIpAddress' \
    --output text \
    --profile $AWS_PROFILE \
    --region $AWS_REGION)

print_success "Public IP: $PUBLIC_IP"
print_success "Private IP: $PRIVATE_IP"
echo ""

# Success output
echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✓ Deployment Complete!                             ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Instance Details:${NC}"
echo -e "  Instance ID:  ${GREEN}$INSTANCE_ID${NC}"
echo -e "  Instance Type: ${GREEN}$INSTANCE_TYPE${NC} (128GB RAM)"
echo -e "  Public IP:    ${GREEN}$PUBLIC_IP${NC}"
echo -e "  Private IP:   ${GREEN}$PRIVATE_IP${NC}"
echo ""
echo -e "${BLUE}SSH Access:${NC}"
echo -e "  ${GREEN}ssh -i ~/.ssh/${KEY_NAME}.pem ec2-user@$PUBLIC_IP${NC}"
echo ""
echo -e "${YELLOW}⏳ Wait 2-3 minutes for initialization to complete${NC}"
echo ""
echo -e "${BLUE}MEOW Principle Verification:${NC}"
echo -e "  ✓ Efficient:      128GB RAM r6i.4xlarge instance"
echo -e "  ✓ Observable:     CloudWatch detailed monitoring enabled"
echo -e "  ✓ Well-documented: Complete deployment record created"
echo ""

# Save deployment info
cat > GEEKCON_DEPLOYMENT.md << EOF
# Geekcon Herbs - Deployment Information

**Date**: $(date)
**Status**: ✅ DEPLOYED
**Region**: $AWS_REGION

## Instance Details
- **Instance ID**: $INSTANCE_ID
- **Type**: $INSTANCE_TYPE (128GB RAM, 16 vCPUs)
- **Public IP**: $PUBLIC_IP
- **Private IP**: $PRIVATE_IP
- **SSH Key**: ~/.ssh/${KEY_NAME}.pem

## SSH Access
\`\`\`bash
ssh -i ~/.ssh/${KEY_NAME}.pem ec2-user@$PUBLIC_IP
\`\`\`

## MEOW Principle
- ✅ **Modular**: Separate components (compute, security, monitoring)
- ✅ **Efficient**: RAM-optimized r6i.4xlarge (128GB RAM)
- ✅ **Observable**: CloudWatch detailed monitoring enabled
- ✅ **Well-documented**: Complete deployment documentation

## Quick Commands
\`\`\`bash
# Check initialization status
ssh -i ~/.ssh/${KEY_NAME}.pem ec2-user@$PUBLIC_IP "tail -f /var/log/cloud-init-output.log"

# Verify services
ssh -i ~/.ssh/${KEY_NAME}.pem ec2-user@$PUBLIC_IP "systemctl status nginx"
ssh -i ~/.ssh/${KEY_NAME}.pem ec2-user@$PUBLIC_IP "systemctl status amazon-cloudwatch-agent"
\`\`\`

## Next Steps
1. Wait for instance initialization (2-3 minutes)
2. SSH into instance and verify services
3. Deploy Geekcon Herbs Next.js application
4. Run Playwright MCP tests
5. Configure domain and SSL certificate
EOF

print_success "Deployment record saved: GEEKCON_DEPLOYMENT.md"
echo ""
print_success "All done! 🎉"
