import { test, expect } from '@playwright/test';

/**
 * Visual Regression Tests for Geekcon Herbs UI
 * 
 * Tests visual appearance against design document specifications
 * Ensures UI components render correctly across browsers and devices
 */

test.describe('Homepage Visual Tests', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
  });

  test('homepage hero section renders correctly', async ({ page }) => {
    // Wait for hero section to load
    await page.waitForSelector('[data-testid="hero-section"]', { state: 'visible' });
    
    // Take screenshot
    await expect(page.locator('[data-testid="hero-section"]')).toHaveScreenshot('hero-section.png', {
      maxDiffPixels: 100,
    });
    
    // Verify H1 is visible
    const h1 = page.locator('h1').first();
    await expect(h1).toBeVisible();
    
    // Verify CTA buttons are present
    const ctaButtons = page.locator('[data-testid="hero-cta"]');
    await expect(ctaButtons).toHaveCount(2);
  });

  test('trust bar displays certification logos', async ({ page }) => {
    const trustBar = page.locator('[data-testid="trust-bar"]');
    await expect(trustBar).toBeVisible();
    
    // Take screenshot
    await expect(trustBar).toHaveScreenshot('trust-bar.png');
    
    // Verify logos are loaded
    const logos = trustBar.locator('img');
    const logoCount = await logos.count();
    expect(logoCount).toBeGreaterThan(0);
    
    // Verify logos are grayscale (CSS filter check)
    const firstLogo = logos.first();
    const filter = await firstLogo.evaluate((el) => 
      window.getComputedStyle(el).filter
    );
    expect(filter).toContain('grayscale');
  });

  test('featured products grid layout is correct', async ({ page }) => {
    const productsGrid = page.locator('[data-testid="featured-products"]');
    await expect(productsGrid).toBeVisible();
    
    // Take screenshot
    await expect(productsGrid).toHaveScreenshot('featured-products.png');
    
    // Verify grid layout on desktop
    const viewport = page.viewportSize();
    if (viewport && viewport.width >= 1024) {
      const gridColumns = await productsGrid.evaluate((el) =>
        window.getComputedStyle(el).gridTemplateColumns
      );
      // Should have 3 columns on desktop
      const columnCount = gridColumns.split(' ').length;
      expect(columnCount).toBe(3);
    }
  });

  test('newsletter CTA section renders correctly', async ({ page }) => {
    const newsletterSection = page.locator('[data-testid="newsletter-cta"]');
    await expect(newsletterSection).toBeVisible();
    
    // Scroll into view
    await newsletterSection.scrollIntoViewIfNeeded();
    
    // Take screenshot
    await expect(newsletterSection).toHaveScreenshot('newsletter-cta.png');
    
    // Verify email input
    const emailInput = newsletterSection.locator('input[type="email"]');
    await expect(emailInput).toBeVisible();
    
    // Verify GDPR checkbox
    const gdprCheckbox = newsletterSection.locator('input[type="checkbox"]');
    await expect(gdprCheckbox).toBeVisible();
  });
});

test.describe('Navigation Visual Tests', () => {
  test('desktop navigation renders correctly', async ({ page, viewport }) => {
    test.skip(viewport.width < 1024, 'Desktop navigation test only');
    
    await page.goto('/');
    
    const header = page.locator('header');
    await expect(header).toBeVisible();
    
    // Take screenshot
    await expect(header).toHaveScreenshot('desktop-navigation.png');
    
    // Verify navigation height (80px per design doc)
    const height = await header.evaluate((el) => el.offsetHeight);
    expect(height).toBe(80);
    
    // Verify logo
    const logo = header.locator('[data-testid="logo"]');
    await expect(logo).toBeVisible();
    const logoWidth = await logo.evaluate((el) => el.offsetWidth);
    expect(logoWidth).toBeCloseTo(160, 10); // 160px ± 10px
  });

  test('mobile navigation renders correctly', async ({ page, viewport }) => {
    test.skip(viewport.width >= 1024, 'Mobile navigation test only');
    
    await page.goto('/');
    
    const header = page.locator('header');
    await expect(header).toBeVisible();
    
    // Take screenshot
    await expect(header).toHaveScreenshot('mobile-navigation.png');
    
    // Verify header height (64px per design doc)
    const height = await header.evaluate((el) => el.offsetHeight);
    expect(height).toBe(64);
    
    // Verify hamburger menu
    const hamburger = header.locator('[data-testid="mobile-menu-button"]');
    await expect(hamburger).toBeVisible();
  });

  test('sticky navigation behavior', async ({ page }) => {
    await page.goto('/');
    
    // Scroll down
    await page.evaluate(() => window.scrollTo(0, 200));
    await page.waitForTimeout(500); // Wait for scroll animation
    
    const header = page.locator('header');
    
    // Check if header has sticky styles
    const position = await header.evaluate((el) =>
      window.getComputedStyle(el).position
    );
    expect(position).toBe('sticky');
    
    // Take screenshot of sticky header
    await expect(header).toHaveScreenshot('sticky-navigation.png');
  });
});

test.describe('Product Card Visual Tests', () => {
  test('product card renders correctly', async ({ page }) => {
    await page.goto('/shop');
    
    const productCard = page.locator('[data-testid="product-card"]').first();
    await expect(productCard).toBeVisible();
    
    // Take screenshot
    await expect(productCard).toHaveScreenshot('product-card.png');
    
    // Verify card structure
    await expect(productCard.locator('img')).toBeVisible(); // Product image
    await expect(productCard.locator('h4')).toBeVisible(); // Product name
    await expect(productCard.locator('[data-testid="product-benefit"]')).toBeVisible(); // Benefit
    await expect(productCard.locator('[data-testid="product-price"]')).toBeVisible(); // Price
    await expect(productCard.locator('button')).toBeVisible(); // CTA button
  });

  test('product card hover state', async ({ page }) => {
    await page.goto('/shop');
    
    const productCard = page.locator('[data-testid="product-card"]').first();
    
    // Hover over card
    await productCard.hover();
    await page.waitForTimeout(300); // Wait for transition
    
    // Take screenshot of hover state
    await expect(productCard).toHaveScreenshot('product-card-hover.png');
    
    // Verify shadow increases on hover
    const boxShadow = await productCard.evaluate((el) =>
      window.getComputedStyle(el).boxShadow
    );
    expect(boxShadow).not.toBe('none');
  });
});

test.describe('Product Detail Page Visual Tests', () => {
  test('product detail page layout is correct', async ({ page }) => {
    // Navigate to a product detail page
    await page.goto('/products/maplau');
    
    // Take full page screenshot
    await expect(page).toHaveScreenshot('product-detail-page.png', {
      fullPage: true,
    });
    
    // Verify breadcrumb
    const breadcrumb = page.locator('[data-testid="breadcrumb"]');
    await expect(breadcrumb).toBeVisible();
    
    // Verify product gallery (left column)
    const gallery = page.locator('[data-testid="product-gallery"]');
    await expect(gallery).toBeVisible();
    
    // Verify product info (right column)
    const productInfo = page.locator('[data-testid="product-info"]');
    await expect(productInfo).toBeVisible();
    
    // Verify tab navigation
    const tabs = page.locator('[data-testid="product-tabs"]');
    await expect(tabs).toBeVisible();
  });

  test('product gallery image ratio is 4:3', async ({ page }) => {
    await page.goto('/products/maplau');
    
    const galleryImage = page.locator('[data-testid="product-gallery"] img').first();
    await expect(galleryImage).toBeVisible();
    
    // Calculate aspect ratio
    const dimensions = await galleryImage.evaluate((img) => ({
      width: img.offsetWidth,
      height: img.offsetHeight,
    }));
    
    const aspectRatio = dimensions.width / dimensions.height;
    expect(aspectRatio).toBeCloseTo(4 / 3, 0.1); // 4:3 ratio ± 0.1
  });
});

test.describe('Cart Drawer Visual Tests', () => {
  test('cart drawer slides from right', async ({ page }) => {
    await page.goto('/');
    
    // Click cart icon
    await page.click('[data-testid="cart-icon"]');
    
    // Wait for drawer animation (300ms per design doc)
    await page.waitForTimeout(300);
    
    const cartDrawer = page.locator('[data-testid="cart-drawer"]');
    await expect(cartDrawer).toBeVisible();
    
    // Take screenshot
    await expect(cartDrawer).toHaveScreenshot('cart-drawer.png');
    
    // Verify drawer width (400px on desktop)
    const viewport = page.viewportSize();
    if (viewport && viewport.width >= 1024) {
      const width = await cartDrawer.evaluate((el) => el.offsetWidth);
      expect(width).toBe(400);
    }
  });

  test('cart drawer subtotal is sticky at bottom', async ({ page }) => {
    await page.goto('/');
    await page.click('[data-testid="cart-icon"]');
    
    const subtotal = page.locator('[data-testid="cart-subtotal"]');
    await expect(subtotal).toBeVisible();
    
    // Verify sticky position
    const position = await subtotal.evaluate((el) =>
      window.getComputedStyle(el).position
    );
    expect(['sticky', 'fixed']).toContain(position);
  });
});

test.describe('Form Visual Tests', () => {
  test('input field dimensions are correct', async ({ page }) => {
    await page.goto('/contact');
    
    const input = page.locator('input[type="text"]').first();
    await expect(input).toBeVisible();
    
    // Verify height (48px per design doc)
    const height = await input.evaluate((el) => el.offsetHeight);
    expect(height).toBe(48);
    
    // Verify padding
    const padding = await input.evaluate((el) => {
      const style = window.getComputedStyle(el);
      return {
        top: parseInt(style.paddingTop),
        right: parseInt(style.paddingRight),
        bottom: parseInt(style.paddingBottom),
        left: parseInt(style.paddingLeft),
      };
    });
    
    expect(padding.top).toBe(12);
    expect(padding.bottom).toBe(12);
    expect(padding.left).toBe(16);
    expect(padding.right).toBe(16);
  });

  test('input focus state has correct styling', async ({ page }) => {
    await page.goto('/contact');
    
    const input = page.locator('input[type="text"]').first();
    await input.focus();
    
    // Take screenshot of focused input
    await expect(input).toHaveScreenshot('input-focused.png');
    
    // Verify focus border color (#1F7A5A)
    const borderColor = await input.evaluate((el) =>
      window.getComputedStyle(el).borderColor
    );
    expect(borderColor).toBe('rgb(31, 122, 90)'); // #1F7A5A in RGB
  });

  test('error state has correct styling', async ({ page }) => {
    await page.goto('/contact');
    
    // Submit form without filling required fields
    await page.click('button[type="submit"]');
    
    // Wait for validation
    await page.waitForTimeout(100);
    
    const errorInput = page.locator('input[aria-invalid="true"]').first();
    await expect(errorInput).toBeVisible();
    
    // Take screenshot
    await expect(errorInput).toHaveScreenshot('input-error.png');
    
    // Verify error border color (#D9534F)
    const borderColor = await errorInput.evaluate((el) =>
      window.getComputedStyle(el).borderColor
    );
    expect(borderColor).toBe('rgb(217, 83, 79)'); // #D9534F in RGB
  });
});

test.describe('Color System Visual Tests', () => {
  test('primary color is used correctly', async ({ page }) => {
    await page.goto('/');
    
    // Find primary button
    const primaryButton = page.locator('button[data-variant="primary"]').first();
    await expect(primaryButton).toBeVisible();
    
    // Verify background color (#1F7A5A)
    const bgColor = await primaryButton.evaluate((el) =>
      window.getComputedStyle(el).backgroundColor
    );
    expect(bgColor).toBe('rgb(31, 122, 90)'); // #1F7A5A
    
    // Verify text color (#FFFFFF)
    const textColor = await primaryButton.evaluate((el) =>
      window.getComputedStyle(el).color
    );
    expect(textColor).toBe('rgb(255, 255, 255)'); // #FFFFFF
  });
});

test.describe('Responsive Visual Tests', () => {
  test('mobile layout stacks vertically', async ({ page }) => {
    // Set mobile viewport
    await page.setViewportSize({ width: 375, height: 812 });
    await page.goto('/');
    
    // Take full page screenshot
    await expect(page).toHaveScreenshot('mobile-homepage.png', {
      fullPage: true,
    });
    
    // Verify featured products are single column
    const productsGrid = page.locator('[data-testid="featured-products"]');
    const gridColumns = await productsGrid.evaluate((el) =>
      window.getComputedStyle(el).gridTemplateColumns
    );
    const columnCount = gridColumns.split(' ').length;
    expect(columnCount).toBe(1);
  });

  test('tablet layout uses 2 columns', async ({ page }) => {
    // Set tablet viewport
    await page.setViewportSize({ width: 768, height: 1024 });
    await page.goto('/shop');
    
    // Take screenshot
    await expect(page).toHaveScreenshot('tablet-shop-page.png', {
      fullPage: true,
    });
    
    // Verify product grid is 2 columns
    const productsGrid = page.locator('[data-testid="products-grid"]');
    const gridColumns = await productsGrid.evaluate((el) =>
      window.getComputedStyle(el).gridTemplateColumns
    );
    const columnCount = gridColumns.split(' ').length;
    expect(columnCount).toBe(2);
  });

  test('desktop layout uses 3 columns', async ({ page }) => {
    // Set desktop viewport
    await page.setViewportSize({ width: 1440, height: 900 });
    await page.goto('/shop');
    
    // Take screenshot
    await expect(page).toHaveScreenshot('desktop-shop-page.png', {
      fullPage: true,
    });
    
    // Verify product grid is 3 columns
    const productsGrid = page.locator('[data-testid="products-grid"]');
    const gridColumns = await productsGrid.evaluate((el) =>
      window.getComputedStyle(el).gridTemplateColumns
    );
    const columnCount = gridColumns.split(' ').length;
    expect(columnCount).toBe(3);
  });
});
