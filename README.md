# Geekcon Herbs  
**Website + Brand + SEO + Generative AI Search Specification**

Version: 1.0  
Status: Hypothetical company (no real-world verification required)  
Primary goal: Build a globally credible Thai herbal brand that ranks in classic SEO **and** is easily cited by generative AI search engines (Perplexity, ChatGPT, Google AI Overviews).

## 🚀 Quick Start

### Prerequisites
- Node.js >= 20.0.0
- npm >= 10.0.0
- AWS CLI (configured with `villaai` profile)
- Gastown infrastructure automation tool

### Initial Setup
```bash
# Clone repository
git clone <repository-url>
cd geekcon-site-demo

# Run setup script
./scripts/setup.sh

# Start development server
npm run dev
```

Visit `http://localhost:3000` to see the application.

### Run Tests
```bash
# Unit tests
npm run test

# E2E tests (Playwright)
npm run test:e2e

# Specific test suites
npm run test:e2e -- tests/playwright/visual-regression.spec.ts
npm run test:e2e -- tests/playwright/accessibility.spec.ts
npm run test:e2e -- tests/playwright/performance.spec.ts
```

## 📋 Project Structure

```
geekcon-site-demo/
├── .github/
│   └── workflows/
│       └── ci-cd.yml              # GitHub Actions CI/CD pipeline
├── scripts/
│   ├── deploy.sh                  # Gastown deployment script
│   ├── init-instance.sh           # EC2 initialization script
│   ├── run-tests.sh               # Playwright test runner
│   └── setup.sh                   # Development setup script
├── tests/
│   └── playwright/
│       ├── visual-regression.spec.ts    # Visual UI tests
│       ├── interaction.spec.ts          # User interaction tests
│       ├── accessibility.spec.ts        # WCAG 2.1 AA tests
│       └── performance.spec.ts          # Core Web Vitals tests
├── DESIGN_DOCUMENT.md             # Comprehensive UI/UX design specs
├── MEOW_WORKFLOW.md               # Development workflow guide
├── DEPLOYMENT_GUIDE.md            # Deployment instructions
├── gastown-config.yml             # Infrastructure configuration
├── playwright.config.ts           # Playwright test configuration
└── package.json                   # Dependencies and scripts
```

## 🏗️ Infrastructure

### Gastown Configuration
- **Instance Type**: r6i.4xlarge (128GB RAM, 16 vCPUs)
- **AWS Profile**: villaai
- **Region**: us-west-2
- **Database**: DynamoDB (PynamoDB protocol)
- **Storage**: S3 for assets and backups
- **Monitoring**: CloudWatch logs and metrics
- **Load Balancer**: Application Load Balancer

### MEOW Principle
Our infrastructure and development workflow follows the **MEOW** principle:
- **M**odular: Clear separation of concerns
- **E**fficient: RAM-optimized instance, performance-focused
- **O**bservable: Comprehensive monitoring and logging
- **W**ell-documented: Complete documentation at all levels

See [MEOW_WORKFLOW.md](./MEOW_WORKFLOW.md) for details.

## 🎨 Design System

Comprehensive design specifications in [DESIGN_DOCUMENT.md](./DESIGN_DOCUMENT.md):
- Color system and typography
- Component library
- Responsive layouts
- Accessibility standards (WCAG 2.1 AA)
- Performance targets (Core Web Vitals)
- Animation and interaction patterns

### Design Highlights
- **Color Palette**: Forest Green (#1F7A5A), Lime Leaf (#A7E8BD), Earth Clay (#C97C5D)
- **Typography**: Inter font family
- **Layout**: Mobile-first, 12-column grid (desktop)
- **Performance**: LCP < 2.5s, FID < 100ms, CLS < 0.1

## 🧪 Testing Strategy

### Automated Testing with Playwright MCP
All UI components are tested against design specifications:

1. **Visual Regression**: Screenshot comparison, layout validation
2. **Interaction**: Button states, form validation, modals, navigation
3. **Accessibility**: Keyboard navigation, ARIA, color contrast, screen readers
4. **Performance**: Core Web Vitals, bundle size, resource loading

### Test Execution
```bash
# Run all tests
npm run test:e2e

# Run with UI
npm run test:e2e:ui

# Run in headed mode
npm run test:e2e:headed

# View test report
npm run test:report
```

## 🚢 Deployment

### Deploy to AWS
```bash
# Using Gastown automation
./scripts/deploy.sh

# Manual steps
export AWS_PROFILE=villaai
export ENVIRONMENT=production
npm run build
# ... see DEPLOYMENT_GUIDE.md for full details
```

See [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) for complete deployment instructions.

## 📊 Monitoring

### CloudWatch Dashboards
- Application health and performance
- Infrastructure metrics (CPU, memory, disk)
- Business metrics (conversions, revenue)
- Error rates and logs

### Key Metrics
- Request rate and response times
- Error rate (target: <1%)
- Core Web Vitals
- Database performance
- Cost tracking

## 📚 Documentation

- **[DESIGN_DOCUMENT.md](./DESIGN_DOCUMENT.md)**: Complete UI/UX specifications
- **[MEOW_WORKFLOW.md](./MEOW_WORKFLOW.md)**: Development workflow and principles
- **[DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)**: Infrastructure and deployment guide
- **[gastown-config.yml](./gastown-config.yml)**: Infrastructure as code

## 🔐 Security

- WAF rules for SQL injection and XSS protection
- Rate limiting (2000 requests per 5 minutes)
- HTTPS only (TLS 1.2+)
- Security headers (X-Frame-Options, CSP, etc.)
- IAM roles with least privilege
- Secrets in AWS Secrets Manager

## 💻 Development

### Code Quality
```bash
# Linting
npm run lint

# Type checking
npm run type-check

# Formatting
npm run format
```

### Git Workflow
- Branch naming: `feature/`, `fix/`, `docs/`
- Commit conventions: Conventional Commits
- Pre-commit hooks: Husky + lint-staged

## 📦 Technology Stack

### Frontend
- **Framework**: Next.js 14
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **Animation**: Framer Motion
- **Forms**: React Hook Form + Zod

### Backend
- **Compute**: AWS EC2 (r6i.4xlarge)
- **Database**: DynamoDB (PynamoDB)
- **Storage**: S3
- **CDN**: CloudFront

### Testing
- **E2E**: Playwright (with MCP integration)
- **Unit**: Jest + React Testing Library
- **Accessibility**: @axe-core/playwright
- **Performance**: Lighthouse CI

### Infrastructure
- **IaC**: Gastown + Terraform
- **CI/CD**: GitHub Actions
- **Monitoring**: CloudWatch
- **Deployment**: Blue-green strategy

## 🎯 Performance Targets

As defined in [DESIGN_DOCUMENT.md](./DESIGN_DOCUMENT.md):

- **LCP**: < 2.5 seconds
- **FID**: < 100 milliseconds
- **CLS**: < 0.1
- **Initial JS Bundle**: < 200KB
- **Total Page Weight**: < 1MB
- **Lighthouse Score**: > 90 (SEO, Performance, Accessibility)

---

## 1. Brand Overview

### Brand Name
**Geekcon Herbs**

### Brand Essence
Ancient Thai herbal intelligence, engineered for modern life.

### Core Positioning
Geekcon Herbs is positioned as:
- The **largest herbal manufacturing facility in Thailand** (hypothetical)
- Operating under **global manufacturing and quality standards**
- Focused on **natural, healthy, science-aligned lifestyle products**
- Designed for **Gen Z and young millennials** who value clarity, transparency, and performance over mysticism

### Brand Personality
- Intelligent
- Calm
- Confident
- Nature-driven but technology-literate
- Zero pseudoscience tone

---

## 2. Target Audience

- Age: 18–35
- Urban, health-conscious
- Interested in fitness, recovery, digestion, immunity, longevity
- Comfortable with e-commerce and subscriptions
- Skeptical of exaggerated health claims
- Heavy mobile users
- Consumes information via search engines and AI tools

---

## 3. Visual Identity

### Color Palette
- Forest Green: `#1F7A5A`
- Lime Leaf: `#A7E8BD`
- Earth Clay: `#C97C5D`
- Off White: `#F6F7F3`
- Charcoal: `#1E1E1E`

### Typography
- Headings: Inter / Space Grotesk
- Body: Inter / SF Pro–style
- Optional accent: monospace for lab or data sections

### Design Language
- Clean, minimal, high white-space
- Botanical macro photography + flat illustrations
- Card-based layouts
- Subtle motion (hover, scroll reveal)
- Icons instead of long text blocks

---

## 4. Product Philosophy

All products must:
- Be plant-based
- Use standardized extracts where applicable
- Be lab-tested for purity and contaminants
- Have transparent sourcing
- Avoid artificial colors, fillers, or unnecessary additives

Available formats:
- Capsules
- Powders
- Teas
- Liquid extracts

---

## 5. Product Lineup

### Core Products

#### 1. Maplau (มะพลู)
**Primary Use:** Digestive comfort / acid reflux support  
- Traditionally used to soothe stomach discomfort  
- Supports digestion and gut balance  

Formats:
- Capsules
- Digestive tea
- Liquid extract

---

#### 2. Fah Talai Jone (ฟ้าทะลายโจร)  
**Botanical Name:** *Andrographis paniculata*  
**Primary Use:** Immune support / cold relief  
- Traditionally used during seasonal illness  
- Supports immune response  

Formats:
- Capsules
- Immune liquid extract

---

#### 3. Turmeric  
**Botanical Name:** *Curcuma longa*  

**Benefits:**
- Supports joint and muscle recovery
- Anti-inflammatory properties
- Antioxidant support
- Digestive health
- Liver support

Geekcon formulation:
- High-curcumin standardized extract
- Black pepper extract for absorption

Formats:
- Capsules
- Recovery powder

---

### Additional Products (10)

4. Ginger Root – digestion, nausea support  
5. Lemongrass – bloating reduction, detox support  
6. Holy Basil (Tulsi) – stress adaptation, cortisol balance  
7. Pandan Leaf – blood sugar balance, calming effect  
8. Galangal – immune and gut support  
9. Fingerroot (Krachai) – circulation, vitality  
10. Mangosteen Peel Extract – antioxidant, skin & immune support  
11. Gotu Kola – cognitive function, circulation, skin repair  
12. Roselle (Hibiscus) – heart health, blood pressure support  
13. Bael Fruit – digestive balance, gut health  

---

## 6. Website Structure

### 6.1 Homepage
Purpose: Trust + brand story + conversion

Sections:
- Hero headline + subheading
- Certifications & standards strip
- Featured products
- “Why Thai herbs?” explanation
- Factory scale & capability section
- Lifestyle imagery
- Primary CTAs (Shop / Build Your Stack)

---

### 6.2 Shop
- Filter by:
  - Health goal
  - Product format
- Subscription options
- Clear product benefit icons
- SEO-friendly category URLs

---

### 6.3 Product Detail Pages
Each product page includes:
- One clear H1
- Botanical + Thai name
- One-sentence summary
- Benefits list
- How it works (simple science)
- How to use
- Safety & who should avoid
- Certifications
- FAQs
- References
- Internal links to related products

---

### 6.4 About Geekcon Herbs
Content focus:
- Thailand’s herbal biodiversity
- Manufacturing scale
- Global quality standards
- Research-driven extraction
- Sustainability and sourcing ethics

---

### 6.5 Learn / Lifestyle Hub
Educational content:
- Herbal guides
- Health routines
- Ingredient explainers
- Comparisons and stacks
- Short, scannable, visual-first articles

---

### 6.6 Cart & Checkout
- Fast checkout
- Apple Pay / Google Pay
- Multi-currency
- International shipping logic

---

## 7. SEO Architecture

### 7.1 Content Hubs
- `/goals/digestion`
- `/goals/immunity`
- `/goals/recovery`
- `/goals/stress-sleep`
- `/ingredients/`
- `/standards/`
- `/factory/`
- `/lab-testing/`
- `/traceability/`

Hub pages link to:
- Products
- Articles
- FAQs

---

### 7.2 On-Page SEO Rules
- One H1 per page
- Logical H2/H3 structure
- Descriptive URLs
- Strong internal linking
- Meta titles (50–60 chars)
- Meta descriptions (140–160 chars)
- Image alt text
- SSR for content pages

---

## 8. Generative AI Search Optimization (GEO)

### 8.1 AI-Friendly Content Blocks
Each product page must include:
- “In one sentence”
- “What it helps with”
- “How to use”
- “Safety notes”
- “References”

### 8.2 Entity Clarity
Always include:
- English name
- Thai name
- Botanical name

Example:
Fah Talai Jone (ฟ้าทะลายโจร) — *Andrographis paniculata*

---

### 8.3 Claim Hygiene
Avoid:
- “Cures”
- “Treats”
- Absolute medical language

Use:
- “Traditionally used”
- “May support”
- “Associated with”

---

### 8.4 References
Each ingredient page should cite:
- Peer-reviewed studies
- WHO or pharmacopeia monographs
- Recognized academic sources

---

## 9. Structured Data (Schema)

Required schema:
- Organization
- Brand
- Product
- Offer
- FAQPage
- Article
- BreadcrumbList
- AggregateRating (when applicable)

Use JSON-LD sitewide.

---

## 10. FAQ Strategy

Each product page:
- 6–10 FAQs
- 3–5 sentence answers
- Clear, neutral language
- High match to real search queries

---

## 11. Technical SEO

Must-have:
- XML sitemap
- Clean robots.txt
- Canonical URLs
- Pagination handling
- Noindex for filters/search pages
- Core Web Vitals compliance

Recommended:
- llms.txt with key URLs
- RSS feed for articles
- humans.txt

---

## 12. Recommended Tech Stack

Frontend:
- Next.js
- Tailwind CSS
- Framer Motion

E-commerce:
- Shopify Headless or Medusa
- Stripe
- Subscription engine

CMS:
- Sanity or Contentful

Infrastructure:
- CDN-first
- SEO-optimized builds
- Fast mobile performance

---

## 13. Brand Taglines (Options)

- Nature, engineered.
- Ancient plants. Modern standards.
- Thai herbs for modern humans.
- Heal naturally. Live intelligently.

---

## 14. Launch QA Checklist

- Lighthouse SEO > 90
- Schema validation passes
- All products have FAQs + references
- All hubs internally linked
- No thin or duplicate pages
- Mobile UX validated

---




make sure that this is dont by gastown and follow meow principle of work including mcp of playwright to test the ui of the website the main focus is on the ui, also the gastown should use the ram optimized ec2 with 128 gb of ram also make sure that the design is controlled by a proper design document