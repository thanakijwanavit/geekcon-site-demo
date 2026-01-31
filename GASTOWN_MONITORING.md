# GASTOWN MONITORING DASHBOARD

## PUBLIC DASHBOARD ACCESS
https://doy5l2hftrxfw.cloudfront.net

**CloudFront Distribution**: E2Z3L03SUVXIAD
**Status**: Deployed (5-15 min propagation)

## GASTOWN STATUS

### Infrastructure (All Active)
- DynamoDB: 3 tables (geekcon-products, geekcon-users, geekcon-orders)
- S3: 2 buckets (assets, backups)
- CloudWatch: 3 log groups (application, nginx, system)
- CloudFront: 1 distribution (monitoring dashboard)

### Monitoring Commands
```bash
# Check status
aws dynamodb list-tables --profile villaai --region ap-southeast-1
aws s3 ls --profile villaai
aws cloudfront get-distribution --id E2Z3L03SUVXIAD --profile villaai

# View logs
aws logs tail /geekcon/application --follow --profile villaai --region ap-southeast-1

# Update dashboard
aws s3 cp monitoring/dashboard.html s3://geekcon-herbs-assets-914499832220/monitoring/index.html --profile villaai
aws cloudfront create-invalidation --distribution-id E2Z3L03SUVXIAD --paths "/*" --profile villaai
```

## DASHBOARD FEATURES
- Real-time DynamoDB status
- S3 storage metrics
- CloudWatch log retention
- Infrastructure details
- Health status
- Auto-refresh every 30s

## ACCESS
- URL: https://doy5l2hftrxfw.cloudfront.net
- Protocol: HTTPS
- Auth: None (public)
- Region: Global (CloudFront)

Status: ALL SYSTEMS OPERATIONAL
