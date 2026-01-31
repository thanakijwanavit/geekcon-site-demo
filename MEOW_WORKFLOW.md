# MEOW Principle Workflow
# Geekcon Herbs - Development & Operations Guide

## MEOW Principle Overview

**MEOW** is our guiding principle for infrastructure and application development:

- **M**odular: Separated, reusable components
- **E**fficient: Optimized for performance and cost
- **O**bservable: Full visibility into system behavior
- **W**ell-documented: Comprehensive documentation at all levels

---

## 1. Modular Architecture

### 1.1 Infrastructure Modules

```
infrastructure/
├── compute/
│   ├── ec2.tf
│   ├── auto-scaling.tf
│   └── load-balancer.tf
├── network/
│   ├── vpc.tf
│   ├── subnets.tf
│   ├── security-groups.tf
│   └── routing.tf
├── storage/
│   ├── s3.tf
│   ├── dynamodb.tf
│   └── backups.tf
├── monitoring/
│   ├── cloudwatch.tf
│   ├── alarms.tf
│   └── dashboards.tf
└── security/
    ├── iam.tf
    ├── secrets.tf
    └── waf.tf
```

### 1.2 Application Modules

```
src/
├── components/          # UI components (atomic design)
│   ├── atoms/
│   ├── molecules/
│   ├── organisms/
│   └── templates/
├── pages/              # Next.js pages
├── lib/                # Utilities and helpers
│   ├── database/
│   ├── api/
│   └── utils/
├── hooks/              # React hooks
├── context/            # React context
├── styles/             # Global styles
└── types/              # TypeScript types
```

### 1.3 Module Independence
- Each module can be developed, tested, and deployed independently
- Clear interfaces between modules
- Minimal coupling, high cohesion
- Version control at module level

---

## 2. Efficient Operations

### 2.1 Performance Optimization

#### Infrastructure Level
- **RAM-optimized EC2**: r6i.4xlarge (128GB RAM)
  - Ensures fast in-memory caching
  - Handles high concurrent users
  - Supports SSR without performance degradation
  
- **gp3 Volumes**: 3000 IOPS for fast disk operations
- **DynamoDB**: On-demand billing, no over-provisioning
- **CDN**: CloudFront for static asset delivery

#### Application Level
- **Next.js ISR**: Incremental Static Regeneration
- **Image Optimization**: WebP with JPEG fallback
- **Code Splitting**: Route-based and component-based
- **Lazy Loading**: Below-the-fold content
- **Caching Strategy**:
  - Static pages: Cache-Control: public, max-age=31536000
  - Dynamic pages: ISR with 60s revalidation
  - API responses: Redis cache (in-memory on EC2)

### 2.2 Cost Efficiency

#### Resource Optimization
- **Right-sizing**: Monitor and adjust instance size monthly
- **Reserved Instances**: Evaluate after 3 months of stable usage
- **S3 Lifecycle**: Auto-transition to cheaper storage classes
- **DynamoDB**: On-demand billing prevents over-provisioning

#### Budget Controls
- Monthly budget: $1,000 (configurable)
- Alerts at 80% and 100% thresholds
- Cost allocation tags for tracking
- Weekly cost reports

### 2.3 Development Efficiency

#### Automated Workflows
```yaml
# CI/CD Pipeline
1. Code Push → GitHub
2. GitHub Actions triggered
3. Run tests (unit, integration, e2e)
4. Run linting and type checking
5. Build application
6. Deploy to staging
7. Run Playwright tests (via MCP)
8. Manual approval for production
9. Blue-green deployment
10. Health checks
11. Rollback if needed
```

#### Developer Experience
- **Hot Reload**: Fast local development
- **Type Safety**: TypeScript throughout
- **Linting**: ESLint + Prettier
- **Pre-commit Hooks**: Husky for quality gates

---

## 3. Observable Systems

### 3.1 Monitoring Layers

#### Infrastructure Monitoring
```
CloudWatch Metrics:
├── EC2
│   ├── CPU Utilization
│   ├── Memory Utilization
│   ├── Disk I/O
│   └── Network Throughput
├── Load Balancer
│   ├── Request Count
│   ├── Target Response Time
│   ├── HTTP 4xx/5xx Errors
│   └── Healthy/Unhealthy Hosts
└── DynamoDB
    ├── Read/Write Capacity
    ├── Throttled Requests
    └── System Errors
```

#### Application Monitoring
```
Custom Metrics:
├── Page Load Times
├── API Response Times
├── Error Rates by Endpoint
├── Conversion Funnel Metrics
├── User Session Duration
└── Cart Abandonment Rate
```

#### User Experience Monitoring
```
Real User Monitoring (RUM):
├── Core Web Vitals
│   ├── LCP (Largest Contentful Paint)
│   ├── FID (First Input Delay)
│   └── CLS (Cumulative Layout Shift)
├── Page Navigation Timing
├── Resource Loading Times
└── JavaScript Errors
```

### 3.2 Logging Strategy

#### Log Levels
```
ERROR:   Application errors, exceptions
WARN:    Potential issues, degraded performance
INFO:    Significant events (login, purchase)
DEBUG:   Detailed diagnostic information
```

#### Log Aggregation
```
CloudWatch Log Groups:
├── /geekcon/application    (30 days retention)
│   ├── error.log
│   ├── access.log
│   └── application.log
├── /geekcon/nginx          (7 days retention)
│   ├── access.log
│   └── error.log
└── /geekcon/system         (14 days retention)
    ├── system.log
    └── auth.log
```

#### Log Insights Queries
```sql
-- Top 10 errors in last hour
fields @timestamp, @message
| filter @message like /ERROR/
| stats count() by @message
| sort count desc
| limit 10

-- Slow API endpoints (>1s)
fields @timestamp, endpoint, duration
| filter duration > 1000
| sort duration desc

-- Failed checkout attempts
fields @timestamp, userId, error
| filter endpoint = "/api/checkout" and status >= 400
```

### 3.3 Alerting

#### Critical Alerts (Immediate Response)
- Service down (health check fails)
- Error rate > 5%
- Response time > 3s (95th percentile)
- Memory usage > 90%
- Disk space > 90%

#### Warning Alerts (Monitor Closely)
- CPU usage > 80% for 5 minutes
- Memory usage > 85%
- Error rate > 1%
- Response time > 1s (95th percentile)

#### Alert Channels
- **Slack**: #geekcon-alerts (all alerts)
- **Email**: dev-team@geekconherbs.com (critical only)
- **PagerDuty**: On-call rotation (critical only, if set up)

### 3.4 Dashboards

#### Operations Dashboard
- System health overview
- Resource utilization
- Request rates and error rates
- Database performance
- Cost tracking

#### Business Dashboard
- Active users
- Conversion rates
- Revenue metrics
- Popular products
- Geographic distribution

---

## 4. Well-documented

### 4.1 Documentation Structure

```
docs/
├── README.md                    # Project overview
├── DESIGN_DOCUMENT.md           # UI/UX specifications (already created)
├── MEOW_WORKFLOW.md            # This file
├── architecture/
│   ├── system-architecture.md
│   ├── data-flow.md
│   └── security.md
├── api/
│   ├── openapi.yaml            # API specifications
│   └── endpoints.md
├── infrastructure/
│   ├── setup-guide.md
│   ├── deployment-guide.md
│   └── troubleshooting.md
├── testing/
│   ├── playwright-tests.md
│   ├── test-strategy.md
│   └── qa-checklist.md
└── runbooks/
    ├── deployment.md
    ├── rollback.md
    ├── incident-response.md
    └── monitoring.md
```

### 4.2 Code Documentation

#### Component Documentation
```typescript
/**
 * ProductCard Component
 * 
 * Displays a product with image, name, price, and CTA button.
 * Used in product grids and related product sections.
 * 
 * @param product - Product object with id, name, price, image
 * @param onAddToCart - Callback when add to cart is clicked
 * @param variant - Display variant ('default' | 'compact')
 * 
 * @example
 * <ProductCard 
 *   product={product} 
 *   onAddToCart={handleAddToCart}
 *   variant="default"
 * />
 */
```

#### Function Documentation
```typescript
/**
 * Fetches product data from DynamoDB
 * 
 * Uses PynamoDB protocol as per project standards.
 * Results are cached for 60 seconds.
 * 
 * @param productId - Unique product identifier
 * @returns Product object or null if not found
 * @throws DatabaseError if connection fails
 */
```

### 4.3 Infrastructure as Documentation

- **Terraform/Gastown Config**: Self-documenting infrastructure
- **Clear naming conventions**: `geekcon-herbs-web-prod`
- **Resource tags**: Purpose, owner, cost center
- **Inline comments**: Explain non-obvious decisions

### 4.4 API Documentation

#### OpenAPI/Swagger
- Endpoint descriptions
- Request/response schemas
- Authentication requirements
- Error codes and messages
- Example requests and responses

#### Interactive API Docs
- Available at `/api/docs` (production)
- Swagger UI for testing endpoints
- Authentication flow examples

### 4.5 Onboarding Documentation

#### New Developer Guide
1. **Setup**:
   - Clone repository
   - Install dependencies: `npm install`
   - Copy `.env.example` to `.env.local`
   - Run locally: `npm run dev`

2. **Architecture Overview**:
   - Read DESIGN_DOCUMENT.md
   - Review system architecture
   - Understand MEOW principles

3. **Development Workflow**:
   - Branch naming: `feature/`, `fix/`, `docs/`
   - Commit conventions: Conventional Commits
   - PR process and review guidelines

4. **Testing**:
   - Unit tests: `npm run test`
   - E2E tests: `npm run test:e2e`
   - Playwright: See testing docs

---

## 5. Workflow Integration

### 5.1 Development Workflow

```
┌─────────────────┐
│  Local Dev      │
│  (npm run dev)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Git Commit     │
│  (pre-commit    │
│   hooks run)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Push to GitHub │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  CI Pipeline    │
│  - Tests        │
│  - Lint         │
│  - Build        │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Deploy Staging │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Playwright MCP │
│  UI Tests       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Manual Review  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Deploy Prod    │
│  (Blue-Green)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Health Checks  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Monitoring     │
└─────────────────┘
```

### 5.2 Playwright MCP Integration

#### Automated UI Testing Flow
```
Deployment Complete
        │
        ▼
Trigger Playwright MCP
        │
        ├─► Visual Regression Tests
        │   └─► Compare screenshots
        │       ├─► Homepage
        │       ├─► Product Pages
        │       └─► Checkout Flow
        │
        ├─► Interaction Tests
        │   └─► Simulate user actions
        │       ├─► Add to Cart
        │       ├─► Form Submissions
        │       └─► Navigation
        │
        ├─► Accessibility Tests
        │   └─► Validate WCAG 2.1 AA
        │       ├─► Keyboard Navigation
        │       ├─► Screen Reader
        │       └─► Color Contrast
        │
        └─► Performance Tests
            └─► Lighthouse Audits
                ├─► Core Web Vitals
                ├─► SEO Score
                └─► Best Practices
        │
        ▼
Generate Test Report
        │
        ├─► All Passed → Continue
        └─► Failures → Alert Team & Rollback Option
```

#### Test Configuration
```javascript
// playwright.config.js
module.exports = {
  testDir: './tests',
  timeout: 30000,
  retries: 2,
  use: {
    baseURL: process.env.TEST_URL,
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'retain-on-failure',
  },
  projects: [
    { name: 'chromium', use: { browserName: 'chromium' } },
    { name: 'firefox', use: { browserName: 'firefox' } },
    { name: 'webkit', use: { browserName: 'webkit' } },
    { name: 'mobile', use: { 
      browserName: 'chromium',
      viewport: { width: 390, height: 844 },
      userAgent: 'iPhone 14'
    }},
  ],
};
```

### 5.3 Incident Response Workflow

```
Alert Triggered
        │
        ▼
Check Dashboard
        │
        ├─► False Alarm → Update Alert Threshold
        │
        └─► Real Issue
                │
                ▼
        Check Runbooks
                │
                ├─► Known Issue → Follow Runbook
                │
                └─► New Issue
                        │
                        ▼
                Investigate Logs
                        │
                        ├─► Application Error → Fix Code
                        ├─► Infrastructure Issue → Scale/Restart
                        └─► External Dependency → Contact Vendor
                        │
                        ▼
                Implement Fix
                        │
                        ▼
                Verify Resolution
                        │
                        ▼
                Document in Runbook
                        │
                        ▼
                Post-mortem (if critical)
```

---

## 6. MEOW Checklist

### Pre-Deployment Checklist

#### Modular ✓
- [ ] Code organized in logical modules
- [ ] Clear separation of concerns
- [ ] Reusable components identified
- [ ] Module dependencies documented

#### Efficient ✓
- [ ] Performance tests passing
- [ ] Bundle size under target
- [ ] Images optimized
- [ ] Caching strategy implemented
- [ ] Database queries optimized
- [ ] Infrastructure right-sized

#### Observable ✓
- [ ] Logging implemented at all levels
- [ ] Metrics exported to CloudWatch
- [ ] Alarms configured
- [ ] Dashboards created
- [ ] Error tracking enabled
- [ ] RUM (Real User Monitoring) active

#### Well-documented ✓
- [ ] README up to date
- [ ] API documentation complete
- [ ] Component documentation added
- [ ] Architecture diagrams current
- [ ] Runbooks written
- [ ] Code comments where needed

---

## 7. Tools & Technologies

### Development
- **Framework**: Next.js 14
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **State**: React Context + Hooks
- **Forms**: React Hook Form
- **Validation**: Zod

### Infrastructure
- **Cloud**: AWS
- **Compute**: EC2 (r6i.4xlarge - 128GB RAM)
- **Database**: DynamoDB (PynamoDB protocol)
- **Storage**: S3
- **CDN**: CloudFront
- **IaC**: Gastown + Terraform

### Testing
- **Unit**: Jest + React Testing Library
- **E2E**: Playwright (via MCP)
- **Visual Regression**: Playwright + Percy
- **Performance**: Lighthouse CI

### Monitoring
- **Metrics**: CloudWatch
- **Logging**: CloudWatch Logs
- **APM**: CloudWatch RUM
- **Alerts**: CloudWatch Alarms + Slack

### CI/CD
- **Version Control**: Git + GitHub
- **CI**: GitHub Actions
- **Deployment**: Gastown (Blue-Green)
- **Secrets**: AWS Secrets Manager

---

## 8. Getting Started with MEOW

### Step 1: Understand the Principles
Read and internalize the MEOW principles. Every decision should be evaluated against these four pillars.

### Step 2: Set Up Your Environment
```bash
# Clone repository
git clone <repo-url>
cd geekcon-site-demo

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env.local

# Run locally
npm run dev
```

### Step 3: Review Documentation
- Read DESIGN_DOCUMENT.md
- Review API documentation
- Understand infrastructure setup

### Step 4: Run Tests
```bash
# Unit tests
npm run test

# E2E tests (requires setup)
npm run test:e2e

# Linting
npm run lint

# Type checking
npm run type-check
```

### Step 5: Deploy to Staging
```bash
# Using Gastown
gastown deploy --environment=staging --profile=villaai

# Or manual
npm run build
# Follow deployment guide
```

### Step 6: Monitor & Iterate
- Check CloudWatch dashboards
- Review test results
- Gather user feedback
- Iterate based on data

---

## 9. Best Practices

### Code Quality
- Write tests first (TDD when possible)
- Use TypeScript strictly (no `any` types)
- Keep functions small and focused
- Follow DRY (Don't Repeat Yourself)
- Comment complex logic only

### Performance
- Measure before optimizing
- Use React.memo judiciously
- Implement code splitting
- Optimize images and assets
- Monitor bundle size

### Security
- Never commit secrets
- Use environment variables
- Implement CSP headers
- Sanitize user inputs
- Keep dependencies updated

### Collaboration
- Write clear commit messages
- Keep PRs small and focused
- Review code thoroughly
- Document decisions
- Share knowledge

---

## 10. Continuous Improvement

### Monthly Reviews
- Review monitoring data
- Analyze performance metrics
- Assess cost efficiency
- Update documentation
- Refine processes

### Quarterly Assessments
- Evaluate infrastructure needs
- Review security posture
- Update technology stack
- Conduct team retrospectives
- Plan improvements

### Annual Planning
- Strategic technology decisions
- Major refactoring initiatives
- Team growth and training
- Tool and platform evaluations

---

## Summary

The MEOW principle ensures our Geekcon Herbs project is:
- **M**odular: Easy to maintain and scale
- **E**fficient: High performance, low cost
- **O**bservable: Full visibility and control
- **W**ell-documented: Easy to onboard and operate

By following this workflow, we build a robust, scalable, and maintainable e-commerce platform that delights users and is a joy for developers to work on.

---

**Last Updated**: January 31, 2026  
**Maintained By**: Gastown Team  
**Next Review**: February 28, 2026
