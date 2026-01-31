import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

/**
 * Accessibility Tests for Geekcon Herbs UI
 * 
 * Tests compliance with WCAG 2.1 AA standards
 * Validates keyboard navigation, ARIA attributes, and screen reader support
 */

test.describe('Keyboard Navigation Tests', () => {
  test('all interactive elements are keyboard accessible', async ({ page }) => {
    await page.goto('/');
    
    // Start tabbing through page
    const tabStops = [];
    let previousFocus = null;
    
    for (let i = 0; i < 50; i++) {
      await page.keyboard.press('Tab');
      await page.waitForTimeout(50);
      
      const focusedElement = await page.evaluate(() => {
        const el = document.activeElement;
        return {
          tagName: el?.tagName,
          id: el?.id,
          className: el?.className,
          type: (el as HTMLInputElement)?.type,
        };
      });
      
      if (JSON.stringify(focusedElement) !== JSON.stringify(previousFocus)) {
        tabStops.push(focusedElement);
        previousFocus = focusedElement;
      }
    }
    
    // Should have multiple tab stops
    expect(tabStops.length).toBeGreaterThan(5);
    
    // All tab stops should be interactive elements
    for (const stop of tabStops) {
      const validTags = ['A', 'BUTTON', 'INPUT', 'TEXTAREA', 'SELECT'];
      expect(validTags).toContain(stop.tagName);
    }
  });

  test('skip to main content link works', async ({ page }) => {
    await page.goto('/');
    
    // Press Tab (should focus skip link)
    await page.keyboard.press('Tab');
    
    // Check if skip link is focused
    const skipLink = page.locator('a[href="#main-content"]');
    await expect(skipLink).toBeFocused();
    
    // Press Enter
    await page.keyboard.press('Enter');
    await page.waitForTimeout(200);
    
    // Main content should be focused
    const mainContent = page.locator('#main-content, main');
    const isInView = await mainContent.evaluate((el) => {
      const rect = el.getBoundingClientRect();
      return rect.top >= 0 && rect.top <= window.innerHeight;
    });
    
    expect(isInView).toBe(true);
  });

  test('modal can be closed with keyboard', async ({ page }) => {
    await page.goto('/');
    
    // Open modal (if exists)
    const openButton = page.locator('[data-testid="open-modal"]').first();
    
    if (await openButton.count() > 0) {
      await openButton.click();
      await page.waitForTimeout(300);
      
      // Press Escape
      await page.keyboard.press('Escape');
      await page.waitForTimeout(300);
      
      // Modal should be closed
      const modal = page.locator('[data-testid="modal"]');
      await expect(modal).not.toBeVisible();
    }
  });

  test('mobile menu can be navigated with keyboard', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 812 });
    await page.goto('/');
    
    // Tab to mobile menu button
    let attempts = 0;
    while (attempts < 20) {
      await page.keyboard.press('Tab');
      const focused = await page.evaluate(() => 
        document.activeElement?.getAttribute('data-testid')
      );
      if (focused === 'mobile-menu-button') break;
      attempts++;
    }
    
    // Press Enter to open menu
    await page.keyboard.press('Enter');
    await page.waitForTimeout(300);
    
    // Menu should be visible
    const menu = page.locator('[data-testid="mobile-menu"]');
    await expect(menu).toBeVisible();
    
    // Tab through menu items
    await page.keyboard.press('Tab');
    const firstLink = await page.evaluate(() => 
      document.activeElement?.tagName
    );
    expect(firstLink).toBe('A');
  });

  test('form inputs can be navigated with Tab', async ({ page }) => {
    await page.goto('/contact');
    
    const inputs = page.locator('input, textarea, select');
    const inputCount = await inputs.count();
    
    // Tab through all inputs
    for (let i = 0; i < inputCount; i++) {
      await page.keyboard.press('Tab');
      await page.waitForTimeout(50);
    }
    
    // Submit button should be focusable
    await page.keyboard.press('Tab');
    const focused = await page.evaluate(() => 
      document.activeElement?.getAttribute('type')
    );
    expect(focused).toBe('submit');
  });

  test('dropdown menu can be navigated with arrow keys', async ({ page }) => {
    await page.goto('/');
    
    const dropdown = page.locator('[data-testid="dropdown-trigger"]').first();
    
    if (await dropdown.count() > 0) {
      // Focus dropdown
      await dropdown.focus();
      
      // Open with Enter
      await page.keyboard.press('Enter');
      await page.waitForTimeout(200);
      
      // Navigate with arrow down
      await page.keyboard.press('ArrowDown');
      await page.waitForTimeout(100);
      
      // First menu item should be focused
      const focusedItem = await page.evaluate(() =>
        document.activeElement?.getAttribute('role')
      );
      expect(focusedItem).toBe('menuitem');
    }
  });
});

test.describe('Focus Management Tests', () => {
  test('focus indicators are visible', async ({ page }) => {
    await page.goto('/');
    
    // Tab to first focusable element
    await page.keyboard.press('Tab');
    await page.waitForTimeout(100);
    
    // Check focus indicator
    const focusedElement = page.locator(':focus');
    await expect(focusedElement).toBeVisible();
    
    // Verify focus outline (should be 2px solid #1F7A5A per design doc)
    const outline = await focusedElement.evaluate((el) => {
      const style = window.getComputedStyle(el);
      return {
        outline: style.outline,
        outlineWidth: style.outlineWidth,
        boxShadow: style.boxShadow,
      };
    });
    
    // Should have either outline or box-shadow for focus
    const hasFocusIndicator = outline.outline !== 'none' || outline.boxShadow !== 'none';
    expect(hasFocusIndicator).toBe(true);
  });

  test('focus returns to trigger after modal close', async ({ page }) => {
    await page.goto('/');
    
    const openButton = page.locator('[data-testid="open-modal"]').first();
    
    if (await openButton.count() > 0) {
      // Focus and click button
      await openButton.focus();
      await openButton.click();
      await page.waitForTimeout(300);
      
      // Close modal
      await page.keyboard.press('Escape');
      await page.waitForTimeout(300);
      
      // Focus should return to open button
      await expect(openButton).toBeFocused();
    }
  });

  test('focus trapped in modal when open', async ({ page }) => {
    await page.goto('/');
    
    const openButton = page.locator('[data-testid="open-modal"]').first();
    
    if (await openButton.count() > 0) {
      await openButton.click();
      await page.waitForTimeout(300);
      
      const modal = page.locator('[data-testid="modal"]');
      
      // Tab through modal multiple times
      for (let i = 0; i < 20; i++) {
        await page.keyboard.press('Tab');
        await page.waitForTimeout(50);
        
        // Check focus is still within modal
        const focusInModal = await page.evaluate(() => {
          const focused = document.activeElement;
          const modal = document.querySelector('[data-testid="modal"]');
          return modal?.contains(focused);
        });
        
        if (i > 5) { // After cycling through modal elements
          expect(focusInModal).toBe(true);
        }
      }
    }
  });
});

test.describe('ARIA Attributes Tests', () => {
  test('buttons have appropriate ARIA labels', async ({ page }) => {
    await page.goto('/');
    
    // Check icon buttons have aria-label
    const iconButtons = page.locator('button[aria-label]');
    const count = await iconButtons.count();
    
    if (count > 0) {
      for (let i = 0; i < count; i++) {
        const ariaLabel = await iconButtons.nth(i).getAttribute('aria-label');
        expect(ariaLabel).toBeTruthy();
        expect(ariaLabel!.length).toBeGreaterThan(0);
      }
    }
  });

  test('form inputs have associated labels', async ({ page }) => {
    await page.goto('/contact');
    
    const inputs = page.locator('input:not([type="hidden"]), textarea, select');
    const inputCount = await inputs.count();
    
    for (let i = 0; i < inputCount; i++) {
      const input = inputs.nth(i);
      const id = await input.getAttribute('id');
      const ariaLabel = await input.getAttribute('aria-label');
      const ariaLabelledBy = await input.getAttribute('aria-labelledby');
      
      // Should have either an id with matching label, aria-label, or aria-labelledby
      if (id) {
        const label = page.locator(`label[for="${id}"]`);
        const hasLabel = (await label.count()) > 0;
        const hasAriaLabel = ariaLabel !== null || ariaLabelledBy !== null;
        
        expect(hasLabel || hasAriaLabel).toBe(true);
      }
    }
  });

  test('navigation has proper landmarks', async ({ page }) => {
    await page.goto('/');
    
    // Check for main landmark
    const main = page.locator('main, [role="main"]');
    await expect(main).toBeVisible();
    
    // Check for navigation landmark
    const nav = page.locator('nav, [role="navigation"]');
    await expect(nav.first()).toBeVisible();
    
    // Check for header
    const header = page.locator('header, [role="banner"]');
    await expect(header).toBeVisible();
    
    // Check for footer
    const footer = page.locator('footer, [role="contentinfo"]');
    const footerCount = await footer.count();
    expect(footerCount).toBeGreaterThan(0);
  });

  test('images have alt text', async ({ page }) => {
    await page.goto('/');
    
    // Get all images
    const images = page.locator('img');
    const imageCount = await images.count();
    
    for (let i = 0; i < Math.min(imageCount, 20); i++) {
      const img = images.nth(i);
      const alt = await img.getAttribute('alt');
      const role = await img.getAttribute('role');
      
      // Decorative images should have role="presentation" or empty alt
      // Content images should have meaningful alt text
      expect(alt !== null).toBe(true);
      
      if (role === 'presentation' || alt === '') {
        // Decorative image - OK to have empty alt
        continue;
      } else {
        // Content image - should have alt text
        expect(alt!.length).toBeGreaterThan(0);
      }
    }
  });

  test('expandable sections have aria-expanded', async ({ page }) => {
    await page.goto('/products/maplau');
    
    const expandButtons = page.locator('[aria-expanded]');
    const count = await expandButtons.count();
    
    if (count > 0) {
      const button = expandButtons.first();
      
      // Get initial state
      const initialExpanded = await button.getAttribute('aria-expanded');
      
      // Click to toggle
      await button.click();
      await page.waitForTimeout(300);
      
      // Get new state
      const newExpanded = await button.getAttribute('aria-expanded');
      
      // State should have toggled
      expect(newExpanded).not.toBe(initialExpanded);
      expect(['true', 'false']).toContain(newExpanded!);
    }
  });

  test('loading states are announced', async ({ page }) => {
    await page.goto('/shop');
    
    // Look for aria-live regions
    const liveRegions = page.locator('[aria-live]');
    const count = await liveRegions.count();
    
    if (count > 0) {
      const liveRegion = liveRegions.first();
      const ariaLive = await liveRegion.getAttribute('aria-live');
      
      // Should be 'polite' or 'assertive'
      expect(['polite', 'assertive']).toContain(ariaLive!);
    }
  });
});

test.describe('Color Contrast Tests', () => {
  test('text has sufficient color contrast', async ({ page }) => {
    await page.goto('/');
    
    // Run Axe accessibility scan focusing on color contrast
    const accessibilityScanResults = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
      .analyze();
    
    // Filter for color contrast violations
    const contrastViolations = accessibilityScanResults.violations.filter(
      (v) => v.id.includes('color-contrast')
    );
    
    expect(contrastViolations).toHaveLength(0);
  });

  test('button text has sufficient contrast', async ({ page }) => {
    await page.goto('/');
    
    const primaryButton = page.locator('button[data-variant="primary"]').first();
    
    if (await primaryButton.count() > 0) {
      const contrast = await primaryButton.evaluate((btn) => {
        const style = window.getComputedStyle(btn);
        return {
          color: style.color,
          backgroundColor: style.backgroundColor,
        };
      });
      
      // Primary button should have white text on green background
      // RGB(255, 255, 255) on RGB(31, 122, 90)
      // This has a contrast ratio of ~4.8:1 (passes AA)
      expect(contrast.color).toBe('rgb(255, 255, 255)');
      expect(contrast.backgroundColor).toBe('rgb(31, 122, 90)');
    }
  });

  test('link text has sufficient contrast', async ({ page }) => {
    await page.goto('/');
    
    const links = page.locator('a');
    const link = links.first();
    
    const color = await link.evaluate((el) =>
      window.getComputedStyle(el).color
    );
    
    // Link color should not be too light
    // Should be visible against background
    expect(color).not.toBe('rgb(255, 255, 255)');
  });
});

test.describe('Screen Reader Support Tests', () => {
  test('page has proper heading hierarchy', async ({ page }) => {
    await page.goto('/');
    
    // Get all headings
    const headings = await page.locator('h1, h2, h3, h4, h5, h6').all();
    
    const headingLevels = await Promise.all(
      headings.map(async (h) => {
        const tagName = await h.evaluate((el) => el.tagName);
        return parseInt(tagName.charAt(1));
      })
    );
    
    // Should have exactly one H1
    const h1Count = headingLevels.filter((l) => l === 1).length;
    expect(h1Count).toBe(1);
    
    // Headings should not skip levels
    for (let i = 1; i < headingLevels.length; i++) {
      const diff = headingLevels[i] - headingLevels[i - 1];
      expect(diff).toBeLessThanOrEqual(1);
    }
  });

  test('form errors are announced', async ({ page }) => {
    await page.goto('/contact');
    
    // Submit form without filling
    await page.click('button[type="submit"]');
    await page.waitForTimeout(100);
    
    // Check for aria-invalid on inputs with errors
    const invalidInputs = page.locator('[aria-invalid="true"]');
    const count = await invalidInputs.count();
    
    if (count > 0) {
      // Check for error message with proper association
      const firstInvalidInput = invalidInputs.first();
      const ariaDescribedBy = await firstInvalidInput.getAttribute('aria-describedby');
      
      if (ariaDescribedBy) {
        const errorMessage = page.locator(`#${ariaDescribedBy}`);
        await expect(errorMessage).toBeVisible();
      }
    }
  });

  test('status messages are in live regions', async ({ page }) => {
    await page.goto('/');
    
    // Add item to cart
    const addToCartButton = page.locator('[data-testid="add-to-cart"]').first();
    
    if (await addToCartButton.count() > 0) {
      await addToCartButton.click();
      await page.waitForTimeout(500);
      
      // Check for success message in live region
      const liveRegion = page.locator('[aria-live][role="status"]');
      const count = await liveRegion.count();
      
      if (count > 0) {
        await expect(liveRegion.first()).toBeVisible();
      }
    }
  });

  test('product cards have accessible names', async ({ page }) => {
    await page.goto('/shop');
    
    const productCards = page.locator('[data-testid="product-card"]');
    const count = await productCards.count();
    
    if (count > 0) {
      for (let i = 0; i < Math.min(count, 5); i++) {
        const card = productCards.nth(i);
        
        // Card should have heading with product name
        const heading = card.locator('h4');
        const headingText = await heading.textContent();
        
        expect(headingText).toBeTruthy();
        expect(headingText!.length).toBeGreaterThan(0);
        
        // Link/button should have accessible name
        const link = card.locator('a').first();
        const ariaLabel = await link.getAttribute('aria-label');
        const linkText = await link.textContent();
        
        const hasAccessibleName = (ariaLabel && ariaLabel.length > 0) || 
                                   (linkText && linkText.length > 0);
        expect(hasAccessibleName).toBe(true);
      }
    }
  });
});

test.describe('Comprehensive Axe Accessibility Tests', () => {
  test('homepage passes axe accessibility scan', async ({ page }) => {
    await page.goto('/');
    
    const accessibilityScanResults = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
      .analyze();
    
    expect(accessibilityScanResults.violations).toEqual([]);
  });

  test('product page passes axe accessibility scan', async ({ page }) => {
    await page.goto('/products/maplau');
    
    const accessibilityScanResults = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
      .analyze();
    
    expect(accessibilityScanResults.violations).toEqual([]);
  });

  test('shop page passes axe accessibility scan', async ({ page }) => {
    await page.goto('/shop');
    
    const accessibilityScanResults = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
      .analyze();
    
    expect(accessibilityScanResults.violations).toEqual([]);
  });

  test('contact form passes axe accessibility scan', async ({ page }) => {
    await page.goto('/contact');
    
    const accessibilityScanResults = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
      .analyze();
    
    expect(accessibilityScanResults.violations).toEqual([]);
  });
});

test.describe('Mobile Accessibility Tests', () => {
  test('touch targets are at least 44x44px', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 812 });
    await page.goto('/');
    
    // Get all buttons and links
    const interactiveElements = page.locator('button, a');
    const count = await interactiveElements.count();
    
    for (let i = 0; i < Math.min(count, 20); i++) {
      const element = interactiveElements.nth(i);
      
      if (await element.isVisible()) {
        const box = await element.boundingBox();
        
        if (box) {
          // Minimum 44x44px per WCAG
          expect(box.width).toBeGreaterThanOrEqual(44);
          expect(box.height).toBeGreaterThanOrEqual(44);
        }
      }
    }
  });

  test('form inputs are at least 16px to prevent zoom', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 812 });
    await page.goto('/contact');
    
    const inputs = page.locator('input, textarea, select');
    const count = await inputs.count();
    
    for (let i = 0; i < count; i++) {
      const input = inputs.nth(i);
      const fontSize = await input.evaluate((el) =>
        parseInt(window.getComputedStyle(el).fontSize)
      );
      
      // Should be at least 16px to prevent iOS zoom
      expect(fontSize).toBeGreaterThanOrEqual(16);
    }
  });
});
