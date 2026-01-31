# Geekcon Herbs Website - UI/UX Design Document

**Version:** 1.0  
**Date:** January 31, 2026  
**Status:** Active  
**Infrastructure:** Gastown-managed ECW with RAM-optimized EC2 (128GB)

---

## 1. Design System Overview

### 1.1 Design Principles
- **Clarity Over Complexity**: Every element serves a clear purpose
- **Science-Backed Aesthetics**: Visual hierarchy mirrors information importance
- **Mobile-First**: 60%+ of traffic expected from mobile devices
- **Performance-Driven**: Design choices optimized for Core Web Vitals
- **Accessibility-First**: WCAG 2.1 AA compliance minimum

### 1.2 Brand Expression in UI
- Modern minimalism with botanical authenticity
- Trust signals prominently displayed
- Zero mysticism or pseudoscience visual language
- Professional without being clinical

---

## 2. Visual Design System

### 2.1 Color System

#### Primary Colors
```
Forest Green (Primary):    #1F7A5A
Lime Leaf (Accent):        #A7E8BD
Earth Clay (Secondary):    #C97C5D
Off White (Background):    #F6F7F3
Charcoal (Text):           #1E1E1E
```

#### Semantic Colors
```
Success:                   #1F7A5A (Forest Green)
Warning:                   #E8B84E
Error:                     #D9534F
Info:                      #5BC0DE
```

#### Opacity Scale
- Primary at 100%, 80%, 60%, 40%, 20%, 10%
- Used for hover states, disabled elements, overlays

### 2.2 Typography System

#### Font Families
```css
--font-heading: 'Inter', -apple-system, system-ui, sans-serif;
--font-body: 'Inter', -apple-system, system-ui, sans-serif;
--font-mono: 'JetBrains Mono', 'SF Mono', monospace;
```

#### Type Scale (Mobile First)
```
H1: 32px/38px (mobile) → 56px/64px (desktop)
H2: 28px/34px (mobile) → 40px/48px (desktop)
H3: 24px/30px (mobile) → 32px/40px (desktop)
H4: 20px/26px (mobile) → 24px/32px (desktop)
Body Large: 18px/28px
Body: 16px/24px
Body Small: 14px/20px
Caption: 12px/16px
```

#### Font Weights
- Light: 300 (sparingly used)
- Regular: 400 (body text)
- Medium: 500 (emphasis)
- Semibold: 600 (subheadings)
- Bold: 700 (headings)

### 2.3 Spacing System

#### Base Unit: 4px

```
Space Scale:
xs:   4px   (0.25rem)
sm:   8px   (0.5rem)
md:   16px  (1rem)
lg:   24px  (1.5rem)
xl:   32px  (2rem)
2xl:  48px  (3rem)
3xl:  64px  (4rem)
4xl:  96px  (6rem)
5xl:  128px (8rem)
```

#### Component Spacing
- Section padding: 48px (mobile) → 96px (desktop)
- Card padding: 24px (mobile) → 32px (desktop)
- Button padding: 12px 24px (mobile) → 16px 32px (desktop)

### 2.4 Layout Grid

#### Breakpoints
```css
mobile:  0px - 639px
tablet:  640px - 1023px
desktop: 1024px - 1439px
wide:    1440px+
```

#### Grid System
- Mobile: 4 columns, 16px gutter
- Tablet: 8 columns, 20px gutter
- Desktop: 12 columns, 24px gutter
- Max width: 1440px

### 2.5 Border Radius System
```
none:   0px
sm:     4px   (buttons, inputs)
md:     8px   (cards)
lg:     12px  (modals)
xl:     16px  (hero sections)
full:   9999px (pills, avatars)
```

### 2.6 Shadow System
```css
--shadow-sm:  0 1px 2px rgba(0,0,0,0.05);
--shadow-md:  0 4px 6px rgba(0,0,0,0.07);
--shadow-lg:  0 10px 15px rgba(0,0,0,0.1);
--shadow-xl:  0 20px 25px rgba(0,0,0,0.1);
```

---

## 3. Component Library

### 3.1 Navigation

#### Desktop Header
- Height: 80px
- Sticky position after 100px scroll
- Background blur effect when scrolling
- Logo: 160px width
- Navigation items: 16px, Medium weight
- CTA button: Primary color, 16px padding

#### Mobile Header
- Height: 64px
- Hamburger menu (right-aligned)
- Full-screen overlay menu
- Smooth slide-in animation (300ms ease)

### 3.2 Buttons

#### Primary Button
```
Background: #1F7A5A
Text: #FFFFFF
Padding: 16px 32px
Border Radius: 4px
Font: 16px, Semibold
Hover: Darken 10%, scale(1.02)
Active: scale(0.98)
Disabled: opacity 0.5, no hover
```

#### Secondary Button
```
Background: transparent
Border: 2px solid #1F7A5A
Text: #1F7A5A
Same dimensions as primary
Hover: Background #1F7A5A, Text #FFFFFF
```

#### Text Button
```
Background: none
Text: #1F7A5A
Underline on hover
```

### 3.3 Cards

#### Product Card
```
Dimensions: Flexible (grid-based)
Padding: 24px
Background: #FFFFFF
Border: 1px solid #E5E5E5
Border Radius: 8px
Shadow: --shadow-sm (default), --shadow-md (hover)
Transition: 200ms ease
```

**Components:**
- Product image (16:9 ratio)
- Product name (H4)
- One-line benefit (Body)
- Price (Body Large, Semibold)
- CTA button

### 3.4 Forms

#### Input Fields
```
Height: 48px
Padding: 12px 16px
Border: 1px solid #D1D5DB
Border Radius: 4px
Font: 16px (prevent zoom on iOS)
Focus: Border #1F7A5A, shadow --shadow-sm
Error: Border #D9534F
```

#### Labels
```
Font: 14px, Medium
Color: #1E1E1E
Margin bottom: 8px
```

### 3.5 Icons
- Line style (outline)
- 24px default size
- 1.5px stroke weight
- Heroicons or Lucide React preferred

---

## 4. Page Templates

### 4.1 Homepage

#### Hero Section
- Full viewport height (100vh)
- Background: Botanical macro photography (60% opacity overlay)
- H1: Center-aligned
- Subheading: Max 600px width
- Dual CTA buttons
- Scroll indicator

#### Trust Bar
- Height: 80px
- Certification logos (grayscale)
- Horizontal scroll on mobile
- Fixed on desktop

#### Featured Products Grid
- 3 columns (desktop) → 1 column (mobile)
- Auto-play carousel on mobile (optional)
- "View All" CTA

#### Why Thai Herbs Section
- 2-column layout
- Left: Image
- Right: Text content
- Reverse on tablet

#### Factory Showcase
- Stats cards (3-4 items)
- Animated counters on scroll
- Background: Off White

#### Newsletter CTA
- Email input + button
- Success message
- GDPR-compliant checkbox

### 4.2 Product Detail Page

#### Layout Structure
1. **Breadcrumb** (top)
2. **Product Gallery + Quick Info** (2-column)
   - Left: Image gallery (4:3 ratio)
   - Right: Name, price, benefits, add to cart
3. **Tab Navigation** (sticky)
   - Benefits | How It Works | How to Use | Safety | FAQs
4. **Content Sections** (single column, max 800px)
5. **Related Products** (carousel)
6. **Reviews** (if available)

#### Visual Hierarchy
- Product name: H1
- Section headings: H2
- Subsections: H3
- Body text: 18px for readability

### 4.3 Shop/Collection Page

#### Filter Sidebar (Desktop)
- Width: 280px
- Sticky on scroll
- Collapsible sections
- Clear all filters option

#### Product Grid
- 3 columns (desktop)
- 2 columns (tablet)
- 1 column (mobile)
- Infinite scroll or pagination (configurable)

#### Sort Dropdown
- Position: Top right
- Options: Best selling, Newest, Price (low-high), Price (high-low)

### 4.4 Cart & Checkout

#### Cart Drawer
- Slide from right
- 400px width (desktop)
- Full width (mobile)
- Subtotal sticky at bottom
- Upsell section

#### Checkout Flow
- Single page checkout
- Progress indicator (top)
- Mobile: Collapsible order summary
- Express checkout options (top): Apple Pay, Google Pay, PayPal

---

## 5. Motion & Animation

### 5.1 Animation Principles
- **Purposeful**: Every animation serves a functional purpose
- **Fast**: Default 200-300ms duration
- **Ease**: cubic-bezier(0.4, 0.0, 0.2, 1) for most transitions
- **Respectful**: Respect prefers-reduced-motion

### 5.2 Standard Transitions
```css
--transition-fast: 150ms ease;
--transition-base: 200ms ease;
--transition-slow: 300ms ease;
--transition-bounce: 400ms cubic-bezier(0.68, -0.55, 0.265, 1.55);
```

### 5.3 Micro-interactions
- Button hover: scale(1.02) + shadow
- Card hover: shadow increase
- Input focus: border color + shadow
- Link hover: color change + underline
- Image load: fade in (300ms)

### 5.4 Page Transitions
- Fade in new content (300ms)
- Slide up for modals (250ms)
- Slide in for drawers (300ms)

### 5.5 Scroll Animations
- Fade in + translate Y (-20px → 0)
- Stagger children (50ms delay)
- Trigger at 20% viewport visibility
- Use Intersection Observer

---

## 6. Responsive Behavior

### 6.1 Mobile Optimizations
- Touch targets: Minimum 44x44px
- Font size: Minimum 16px (inputs to prevent zoom)
- Reduce animation complexity
- Stack layouts vertically
- Full-width CTAs
- Sticky add-to-cart on product pages

### 6.2 Tablet Considerations
- 2-column layouts where appropriate
- Readable line lengths (60-80 characters)
- Touch-friendly but utilize screen space

### 6.3 Desktop Enhancements
- Hover states fully utilized
- Multi-column layouts
- Sticky sidebars
- Cursor-based interactions

---

## 7. Performance Specifications

### 7.1 Core Web Vitals Targets
```
LCP (Largest Contentful Paint):    < 2.5s
FID (First Input Delay):            < 100ms
CLS (Cumulative Layout Shift):      < 0.1
```

### 7.2 Image Optimization
- WebP format with JPEG fallback
- Lazy loading (below fold)
- Responsive images (srcset)
- Max file size: 200KB (hero), 100KB (products)
- Dimensions: Predefined to prevent CLS

### 7.3 Font Loading
- Font display: swap
- Preload critical fonts
- Subset fonts (Latin only if applicable)
- WOFF2 format

### 7.4 Code Splitting
- Route-based code splitting
- Dynamic imports for modals/drawers
- Lazy load non-critical components
- Bundle size target: < 200KB initial JS

---

## 8. Accessibility Standards

### 8.1 Keyboard Navigation
- All interactive elements focusable
- Visible focus indicators (2px solid #1F7A5A)
- Logical tab order
- Skip to main content link
- Escape to close modals/menus

### 8.2 Screen Reader Support
- Semantic HTML elements
- ARIA labels where needed
- Alt text for all images
- Form labels properly associated
- Status messages announced

### 8.3 Color Contrast
- Text on background: Minimum 4.5:1
- Large text (18px+): Minimum 3:1
- Interactive elements: Minimum 3:1

### 8.4 Forms Accessibility
- Label for every input
- Error messages linked (aria-describedby)
- Required fields indicated
- Error states clearly visible

---

## 9. Testing Requirements

### 9.1 Browser Support
- Chrome (last 2 versions)
- Firefox (last 2 versions)
- Safari (last 2 versions)
- Edge (last 2 versions)
- Mobile Safari (iOS 14+)
- Chrome Mobile (Android 10+)

### 9.2 Device Testing
- iPhone 12/13/14 (375px, 390px)
- iPad (768px, 1024px)
- Desktop (1280px, 1440px, 1920px)

### 9.3 Playwright UI Testing (MCP)
All UI components must pass automated tests:

#### Visual Regression Tests
- Homepage hero section
- Product cards grid
- Navigation (desktop & mobile)
- Product detail page layout
- Cart drawer
- Checkout flow

#### Interaction Tests
- Button hover/active states
- Form input validation
- Modal open/close
- Carousel navigation
- Filter interactions
- Add to cart flow

#### Accessibility Tests
- Keyboard navigation paths
- Focus management
- ARIA attributes
- Color contrast ratios
- Screen reader announcements

#### Performance Tests
- Lighthouse scores (Mobile & Desktop)
- Core Web Vitals
- Time to Interactive
- Bundle size analysis

---

## 10. Design Tokens (Implementation)

### 10.1 CSS Variables
```css
:root {
  /* Colors */
  --color-primary: #1F7A5A;
  --color-accent: #A7E8BD;
  --color-secondary: #C97C5D;
  --color-bg: #F6F7F3;
  --color-text: #1E1E1E;
  
  /* Spacing */
  --space-xs: 0.25rem;
  --space-sm: 0.5rem;
  --space-md: 1rem;
  --space-lg: 1.5rem;
  --space-xl: 2rem;
  --space-2xl: 3rem;
  --space-3xl: 4rem;
  --space-4xl: 6rem;
  
  /* Typography */
  --font-heading: 'Inter', sans-serif;
  --font-body: 'Inter', sans-serif;
  --font-mono: 'JetBrains Mono', monospace;
  
  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.07);
  --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
  
  /* Border Radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  
  /* Transitions */
  --transition-fast: 150ms ease;
  --transition-base: 200ms ease;
  --transition-slow: 300ms ease;
}
```

---

## 11. Content Guidelines

### 11.1 Image Requirements
- Hero images: 1920x1080px (16:9)
- Product images: 800x800px (1:1)
- Lifestyle images: 1200x800px (3:2)
- Thumbnails: 400x400px (1:1)
- Icons: SVG format, 24x24px viewport

### 11.2 Copy Guidelines
- Headlines: 5-10 words maximum
- Subheadings: 10-20 words maximum
- Body paragraphs: 2-4 sentences
- Button text: 1-3 words
- Product benefits: 1 sentence each

### 11.3 Tone of Voice (UI Copy)
- Direct and confident
- No exclamation marks (except special occasions)
- Active voice preferred
- Avoid jargon unless industry-standard
- Gen Z friendly without trying too hard

---

## 12. Quality Assurance Checklist

### Pre-Launch QA
- [ ] All pages load in < 3 seconds (3G)
- [ ] Zero console errors
- [ ] All images have alt text
- [ ] All forms validate properly
- [ ] Mobile menu works correctly
- [ ] Cart functionality complete
- [ ] Checkout flow tested end-to-end
- [ ] All links work (no 404s)
- [ ] Favicon and meta tags present
- [ ] GDPR cookie banner (if EU traffic)
- [ ] Privacy policy linked
- [ ] Terms of service linked
- [ ] Contact information visible
- [ ] Social media links (if applicable)
- [ ] Search functionality works
- [ ] 404 page designed
- [ ] Thank you pages styled
- [ ] Email templates match brand

### Playwright Automated Checks
- [ ] Visual regression suite passing
- [ ] Interaction tests passing
- [ ] Accessibility tests passing
- [ ] Performance budgets met
- [ ] Cross-browser tests passing
- [ ] Mobile tests passing

---

## 13. Maintenance & Iteration

### 13.1 Analytics Integration
- Google Analytics 4
- Hotjar or similar (heatmaps)
- Core Web Vitals monitoring
- Error tracking (Sentry)

### 13.2 A/B Testing Framework
- Homepage hero variants
- CTA button text/color
- Product card layouts
- Checkout flow steps

### 13.3 Design System Updates
- Quarterly review of component library
- Monthly performance audits
- Continuous accessibility monitoring
- User feedback integration

---

## 14. Handoff Specifications

### 14.1 Developer Handoff
- Figma file with dev mode enabled
- All spacing/sizing in px (converted to rem in code)
- Color codes in hex
- Font files provided
- Component states documented
- Interaction notes in Figma

### 14.2 Content Team Handoff
- Image dimension requirements
- Copy length guidelines
- SEO requirements per page type
- Alt text guidelines
- Tone of voice document

---

## Document Changelog

### Version 1.0 - January 31, 2026
- Initial design document created
- Full component library specified
- Testing requirements with Playwright MCP
- Performance and accessibility standards defined
- Infrastructure notes: Gastown ECW, RAM-optimized EC2 128GB

---

**Approved By:** Gastown Infrastructure Team  
**Next Review:** February 28, 2026  
**Status:** Ready for Implementation
