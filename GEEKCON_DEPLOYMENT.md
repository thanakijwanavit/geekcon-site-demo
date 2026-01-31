# Geekcon Herbs - Deployment Information

**Date**: Sun Feb  1 01:32:36 +07 2026
**Status**: ✅ DEPLOYED
**Region**: ap-southeast-1

## Instance Details
- **Instance ID**: i-0049cfb72e9633897
- **Type**: r6i.4xlarge (128GB RAM, 16 vCPUs)
- **Public IP**: 13.215.224.99
- **Private IP**: 172.31.10.70
- **SSH Key**: ~/.ssh/geekcon-herbs-key.pem

## SSH Access
```bash
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99
```

## MEOW Principle
- ✅ **Modular**: Separate components (compute, security, monitoring)
- ✅ **Efficient**: RAM-optimized r6i.4xlarge (128GB RAM)
- ✅ **Observable**: CloudWatch detailed monitoring enabled
- ✅ **Well-documented**: Complete deployment documentation

## Quick Commands
```bash
# Check initialization status
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99 "tail -f /var/log/cloud-init-output.log"

# Verify services
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99 "systemctl status nginx"
ssh -i ~/.ssh/geekcon-herbs-key.pem ec2-user@13.215.224.99 "systemctl status amazon-cloudwatch-agent"
```

## Next Steps
1. Wait for instance initialization (2-3 minutes)
2. SSH into instance and verify services
3. Deploy Geekcon Herbs Next.js application
4. Run Playwright MCP tests
5. Configure domain and SSL certificate
