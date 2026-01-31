# Geekcon Herbs - Pre-Deployment Checklist

Use this checklist before deploying to production.

## 📋 Infrastructure Setup

### AWS Configuration
- [ ] AWS CLI installed and configured
- [ ] AWS profile `villaai` configured with correct credentials
- [ ] AWS region set to `us-west-2` (or desired region)
- [ ] AWS account has sufficient limits for resources
- [ ] IAM roles and policies reviewed and approved

### Gastown Configuration
- [ ] Gastown tool installed and configured
- [ ] `gastown-config.yml` reviewed and validated
- [ ] Instance type confirmed (r6i.4xlarge - 128GB RAM)
- [ ] VPC CIDR blocks verified (no conflicts)
- [ ] Security group rules reviewed
- [ ] DynamoDB table names finalized
- [ ] S3 bucket names verified (globally unique)

### Domain & SSL
- [ ] Domain name registered
- [ ] Route53 hosted zone created
- [ ] SSL certificate requested in ACM
- [ ] SSL certificate validated and issued
- [ ] DNS records prepared

## 🔧 Application Setup

### Code Repository
- [ ] Code repository initialized
- [ ] `.gitignore` configured
- [ ] `.env.example` created
- [ ] All secrets removed from code
- [ ] Git hooks configured (Husky)

### Dependencies
- [ ] Node.js >= 20.0.0 installed
- [ ] npm >= 10.0.0 installed
- [ ] All npm dependencies installed (`npm ci`)
- [ ] Playwright browsers installed
- [ ] No critical security vulnerabilities in dependencies

### Environment Variables
- [ ] `.env.local` created (local development)
- [ ] Production secrets added to AWS Secrets Manager
- [ ] Environment variables documented
- [ ] No secrets in git history

### Code Quality
- [ ] Linting passes (`npm run lint`)
- [ ] Type checking passes (`npm run type-check`)
- [ ] Unit tests pass (`npm run test`)
- [ ] Code formatted (`npm run format`)

## 🧪 Testing

### Playwright Tests
- [ ] Playwright configuration reviewed
- [ ] All test files created and reviewed
- [ ] Visual regression tests pass
- [ ] Interaction tests pass
- [ ] Accessibility tests pass
- [ ] Performance tests pass
- [ ] Test results documented

### Manual Testing
- [ ] Application builds successfully (`npm run build`)
- [ ] Application runs locally (`npm run dev`)
- [ ] All pages load correctly
- [ ] Navigation works
- [ ] Forms validate correctly
- [ ] Mobile responsive design verified

## 📚 Documentation

### Required Documents
- [ ] README.md complete with quick start guide
- [ ] DESIGN_DOCUMENT.md finalized
- [ ] MEOW_WORKFLOW.md reviewed
- [ ] DEPLOYMENT_GUIDE.md complete
- [ ] PROJECT_SUMMARY.md reviewed
- [ ] API documentation (if applicable)

### Code Documentation
- [ ] All components have JSDoc comments
- [ ] Complex functions documented
- [ ] README includes all npm scripts
- [ ] Architecture diagrams created (if needed)

## 🚀 Deployment Preparation

### Pre-Deployment
- [ ] All checklist items above completed
- [ ] Backup strategy confirmed
- [ ] Rollback plan documented
- [ ] Deployment window scheduled
- [ ] Team notified of deployment

### Deployment Scripts
- [ ] `scripts/deploy.sh` reviewed and tested
- [ ] `scripts/init-instance.sh` reviewed
- [ ] `scripts/run-tests.sh` tested locally
- [ ] All scripts have execute permissions

### CI/CD Pipeline
- [ ] GitHub Actions workflow configured
- [ ] GitHub secrets configured
- [ ] Pipeline tested on feature branch
- [ ] Deployment approvals configured

## 📊 Monitoring

### CloudWatch Setup
- [ ] Log groups created
- [ ] Metric namespaces defined
- [ ] Alarms configured
- [ ] Dashboards created
- [ ] SNS topics for notifications (if applicable)

### Alerting
- [ ] Critical alarms defined
- [ ] Warning alarms defined
- [ ] Alert recipients configured
- [ ] Slack webhook configured (optional)
- [ ] On-call rotation defined (if applicable)

## 🔒 Security

### Security Review
- [ ] WAF rules configured
- [ ] Rate limiting enabled
- [ ] Security headers configured
- [ ] HTTPS enforced
- [ ] Secrets in AWS Secrets Manager
- [ ] IAM roles follow least privilege
- [ ] Security groups are restrictive
- [ ] No public S3 buckets (unless intended)

### Compliance
- [ ] GDPR requirements reviewed (if applicable)
- [ ] Privacy policy in place
- [ ] Terms of service in place
- [ ] Cookie consent implemented (if needed)

## 💰 Cost Management

### Budget
- [ ] Monthly budget defined
- [ ] Cost allocation tags configured
- [ ] Budget alerts configured (80%, 100%)
- [ ] Cost optimization reviewed
- [ ] Reserved instances considered (after 3 months)

## 🎯 Performance

### Performance Targets
- [ ] Core Web Vitals targets defined
- [ ] Performance budget set
- [ ] Lighthouse CI configured
- [ ] Performance monitoring enabled
- [ ] CDN configured (CloudFront)

### Optimization
- [ ] Images optimized (WebP, lazy loading)
- [ ] Code split properly
- [ ] Fonts optimized and preloaded
- [ ] Caching strategy implemented
- [ ] Bundle size under target (<200KB)

## 📱 User Experience

### Design Implementation
- [ ] Design system implemented
- [ ] All components match design specs
- [ ] Responsive design tested
- [ ] Browser compatibility verified
- [ ] Mobile devices tested

### Accessibility
- [ ] WCAG 2.1 AA compliance verified
- [ ] Keyboard navigation tested
- [ ] Screen reader tested
- [ ] Color contrast verified
- [ ] Touch targets >= 44x44px

## 🔄 Post-Deployment

### Immediate Actions
- [ ] Health checks passing
- [ ] Smoke tests executed
- [ ] Playwright tests run on production
- [ ] Monitoring dashboards reviewed
- [ ] Logs reviewed for errors

### First 24 Hours
- [ ] Monitor error rates
- [ ] Monitor performance metrics
- [ ] Check user feedback
- [ ] Review CloudWatch alarms
- [ ] Verify backups working

### First Week
- [ ] Review all metrics
- [ ] Optimize as needed
- [ ] Update documentation based on learnings
- [ ] Schedule retrospective
- [ ] Plan next improvements

## ✅ Sign-Off

Before deployment, ensure sign-off from:

- [ ] **Technical Lead**: Code quality and architecture _______________
- [ ] **DevOps Lead**: Infrastructure and deployment _______________
- [ ] **QA Lead**: Testing and quality assurance _______________
- [ ] **Security Lead**: Security review _______________
- [ ] **Product Owner**: Business requirements _______________

---

**Deployment Date**: _____________________  
**Deployed By**: _____________________  
**Deployment Status**: ⬜ Success ⬜ Rolled Back ⬜ Issues  

**Notes**:
_____________________________________________________________________
_____________________________________________________________________
_____________________________________________________________________

---

**Last Updated**: January 31, 2026  
**Version**: 1.0
