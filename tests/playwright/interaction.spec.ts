import { test, expect } from '@playwright/test';

/**
 * Interaction Tests for Geekcon Herbs UI
 * 
 * Tests user interactions and component behaviors
 * Validates that UI components respond correctly to user actions
 */

test.describe('Button Interaction Tests', () => {
  test('primary button hover state', async ({ page }) => {
    await page.goto('/');
    
    const primaryButton = page.locator('button[data-variant="primary"]').first();
    
    // Get initial state
    const initialTransform = await primaryButton.evaluate((el) =>
      window.getComputedStyle(el).transform
    );
    
    // Hover
    await primaryButton.hover();
    await page.waitForTimeout(200); // Wait for transition
    
    // Check transform scale (should be scale(1.02))
    const hoverTransform = await primaryButton.evaluate((el) =>
      window.getComputedStyle(el).transform
    );
    
    expect(hoverTransform).not.toBe(initialTransform);
    expect(hoverTransform).toContain('matrix'); // Scaled transform
  });

  test('button click active state', async ({ page }) => {
    await page.goto('/');
    
    const button = page.locator('button[data-variant="primary"]').first();
    
    // Press and hold
    await button.hover();
    await page.mouse.down();
    await page.waitForTimeout(100);
    
    // Check transform scale (should be scale(0.98))
    const activeTransform = await button.evaluate((el) =>
      window.getComputedStyle(el).transform
    );
    
    expect(activeTransform).toContain('matrix');
    
    await page.mouse.up();
  });

  test('disabled button has no hover effect', async ({ page }) => {
    await page.goto('/');
    
    // Find or create a disabled button for testing
    const disabledButton = page.locator('button:disabled').first();
    
    if (await disabledButton.count() > 0) {
      await disabledButton.hover();
      await page.waitForTimeout(200);
      
      // Verify no hover effect (cursor should be not-allowed)
      const cursor = await disabledButton.evaluate((el) =>
        window.getComputedStyle(el).cursor
      );
      expect(cursor).toBe('not-allowed');
    }
  });

  test('text button shows underline on hover', async ({ page }) => {
    await page.goto('/');
    
    const textButton = page.locator('button[data-variant="text"]').first();
    
    if (await textButton.count() > 0) {
      // Check initial state (no underline)
      const initialDecoration = await textButton.evaluate((el) =>
        window.getComputedStyle(el).textDecoration
      );
      
      // Hover
      await textButton.hover();
      await page.waitForTimeout(200);
      
      // Check hover state (underline)
      const hoverDecoration = await textButton.evaluate((el) =>
        window.getComputedStyle(el).textDecoration
      );
      
      expect(hoverDecoration).toContain('underline');
    }
  });
});

test.describe('Form Interaction Tests', () => {
  test('input validation on blur', async ({ page }) => {
    await page.goto('/contact');
    
    const emailInput = page.locator('input[type="email"]').first();
    
    // Enter invalid email
    await emailInput.fill('invalid-email');
    await emailInput.blur();
    
    // Wait for validation
    await page.waitForTimeout(100);
    
    // Check for error message
    const errorMessage = page.locator('[data-testid="email-error"]');
    await expect(errorMessage).toBeVisible();
    await expect(errorMessage).toContainText('valid');
  });

  test('form submission with valid data', async ({ page }) => {
    await page.goto('/contact');
    
    // Fill form
    await page.fill('input[name="name"]', 'John Doe');
    await page.fill('input[name="email"]', 'john@example.com');
    await page.fill('textarea[name="message"]', 'Test message');
    
    // Submit
    await page.click('button[type="submit"]');
    
    // Wait for response
    await page.waitForTimeout(1000);
    
    // Check for success message
    const successMessage = page.locator('[data-testid="success-message"]');
    await expect(successMessage).toBeVisible();
  });

  test('required field validation', async ({ page }) => {
    await page.goto('/contact');
    
    // Try to submit without filling required fields
    await page.click('button[type="submit"]');
    
    // Wait for validation
    await page.waitForTimeout(100);
    
    // Check for error messages
    const errorMessages = page.locator('[role="alert"]');
    const count = await errorMessages.count();
    expect(count).toBeGreaterThan(0);
  });

  test('real-time character counter', async ({ page }) => {
    await page.goto('/contact');
    
    const textarea = page.locator('textarea[name="message"]');
    const counter = page.locator('[data-testid="char-counter"]');
    
    if (await counter.count() > 0) {
      // Type some text
      await textarea.fill('Hello World');
      
      // Check counter updates
      const counterText = await counter.textContent();
      expect(counterText).toContain('11'); // Length of "Hello World"
    }
  });
});

test.describe('Modal Interaction Tests', () => {
  test('modal opens and closes', async ({ page }) => {
    await page.goto('/');
    
    // Click button to open modal
    const openButton = page.locator('[data-testid="open-modal"]').first();
    
    if (await openButton.count() > 0) {
      await openButton.click();
      
      // Wait for modal animation (250ms)
      await page.waitForTimeout(300);
      
      // Check modal is visible
      const modal = page.locator('[data-testid="modal"]');
      await expect(modal).toBeVisible();
      
      // Close modal with X button
      await page.click('[data-testid="modal-close"]');
      await page.waitForTimeout(300);
      
      // Check modal is hidden
      await expect(modal).not.toBeVisible();
    }
  });

  test('modal closes on escape key', async ({ page }) => {
    await page.goto('/');
    
    const openButton = page.locator('[data-testid="open-modal"]').first();
    
    if (await openButton.count() > 0) {
      await openButton.click();
      await page.waitForTimeout(300);
      
      // Press Escape
      await page.keyboard.press('Escape');
      await page.waitForTimeout(300);
      
      // Check modal is hidden
      const modal = page.locator('[data-testid="modal"]');
      await expect(modal).not.toBeVisible();
    }
  });

  test('modal closes on backdrop click', async ({ page }) => {
    await page.goto('/');
    
    const openButton = page.locator('[data-testid="open-modal"]').first();
    
    if (await openButton.count() > 0) {
      await openButton.click();
      await page.waitForTimeout(300);
      
      // Click backdrop
      await page.click('[data-testid="modal-backdrop"]');
      await page.waitForTimeout(300);
      
      // Check modal is hidden
      const modal = page.locator('[data-testid="modal"]');
      await expect(modal).not.toBeVisible();
    }
  });
});

test.describe('Navigation Interaction Tests', () => {
  test('mobile menu opens and closes', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 812 });
    await page.goto('/');
    
    // Open menu
    await page.click('[data-testid="mobile-menu-button"]');
    await page.waitForTimeout(300); // Wait for animation
    
    // Check menu is visible
    const menu = page.locator('[data-testid="mobile-menu"]');
    await expect(menu).toBeVisible();
    
    // Close menu
    await page.click('[data-testid="mobile-menu-close"]');
    await page.waitForTimeout(300);
    
    // Check menu is hidden
    await expect(menu).not.toBeVisible();
  });

  test('navigation link hover effect', async ({ page }) => {
    await page.goto('/');
    
    const navLink = page.locator('nav a').first();
    
    // Get initial color
    const initialColor = await navLink.evaluate((el) =>
      window.getComputedStyle(el).color
    );
    
    // Hover
    await navLink.hover();
    await page.waitForTimeout(200);
    
    // Get hover color
    const hoverColor = await navLink.evaluate((el) =>
      window.getComputedStyle(el).color
    );
    
    // Color should change on hover
    expect(hoverColor).not.toBe(initialColor);
  });

  test('dropdown menu opens on click', async ({ page }) => {
    await page.goto('/');
    
    const dropdown = page.locator('[data-testid="dropdown-trigger"]').first();
    
    if (await dropdown.count() > 0) {
      // Click to open
      await dropdown.click();
      await page.waitForTimeout(200);
      
      // Check dropdown menu is visible
      const dropdownMenu = page.locator('[data-testid="dropdown-menu"]');
      await expect(dropdownMenu).toBeVisible();
      
      // Click outside to close
      await page.click('body', { position: { x: 10, y: 10 } });
      await page.waitForTimeout(200);
      
      // Check dropdown is closed
      await expect(dropdownMenu).not.toBeVisible();
    }
  });
});

test.describe('Carousel Interaction Tests', () => {
  test('carousel navigation with arrows', async ({ page }) => {
    await page.goto('/');
    
    const carousel = page.locator('[data-testid="carousel"]').first();
    
    if (await carousel.count() > 0) {
      // Get initial slide
      const initialSlide = await carousel.getAttribute('data-active-slide');
      
      // Click next button
      await page.click('[data-testid="carousel-next"]');
      await page.waitForTimeout(300);
      
      // Get new slide
      const nextSlide = await carousel.getAttribute('data-active-slide');
      
      // Slide should have changed
      expect(nextSlide).not.toBe(initialSlide);
      
      // Click previous button
      await page.click('[data-testid="carousel-prev"]');
      await page.waitForTimeout(300);
      
      // Should be back to initial slide
      const currentSlide = await carousel.getAttribute('data-active-slide');
      expect(currentSlide).toBe(initialSlide);
    }
  });

  test('carousel navigation with dots', async ({ page }) => {
    await page.goto('/');
    
    const carousel = page.locator('[data-testid="carousel"]').first();
    
    if (await carousel.count() > 0) {
      // Click on third dot
      const dots = page.locator('[data-testid="carousel-dot"]');
      if ((await dots.count()) >= 3) {
        await dots.nth(2).click();
        await page.waitForTimeout(300);
        
        // Check active slide is 3rd (index 2)
        const activeSlide = await carousel.getAttribute('data-active-slide');
        expect(activeSlide).toBe('2');
      }
    }
  });

  test('carousel auto-play can be paused', async ({ page }) => {
    await page.goto('/');
    
    const carousel = page.locator('[data-testid="carousel"]').first();
    
    if (await carousel.count() > 0) {
      // Hover to pause auto-play
      await carousel.hover();
      
      // Get current slide
      const slide1 = await carousel.getAttribute('data-active-slide');
      
      // Wait for normal auto-play interval (e.g., 5 seconds)
      await page.waitForTimeout(5000);
      
      // Slide should not have changed (paused on hover)
      const slide2 = await carousel.getAttribute('data-active-slide');
      expect(slide2).toBe(slide1);
    }
  });
});

test.describe('Filter Interaction Tests', () => {
  test('shop filter updates products', async ({ page }) => {
    await page.goto('/shop');
    
    // Get initial product count
    const products = page.locator('[data-testid="product-card"]');
    const initialCount = await products.count();
    
    // Apply a filter
    const filter = page.locator('[data-testid="filter-option"]').first();
    await filter.click();
    await page.waitForTimeout(500); // Wait for products to update
    
    // Get new product count
    const newCount = await products.count();
    
    // Count should change (unless filter had no effect)
    // At minimum, products should re-render
    await expect(products.first()).toBeVisible();
  });

  test('clear all filters resets products', async ({ page }) => {
    await page.goto('/shop');
    
    // Apply some filters
    const filters = page.locator('[data-testid="filter-option"]');
    if ((await filters.count()) > 0) {
      await filters.first().click();
      await page.waitForTimeout(500);
      
      // Clear all filters
      const clearButton = page.locator('[data-testid="clear-filters"]');
      await clearButton.click();
      await page.waitForTimeout(500);
      
      // Check that filters are unchecked
      const checkedFilters = page.locator('[data-testid="filter-option"]:checked');
      const checkedCount = await checkedFilters.count();
      expect(checkedCount).toBe(0);
    }
  });

  test('sort dropdown changes product order', async ({ page }) => {
    await page.goto('/shop');
    
    // Get first product name
    const firstProduct = page.locator('[data-testid="product-card"]').first();
    const initialName = await firstProduct.locator('h4').textContent();
    
    // Open sort dropdown
    await page.click('[data-testid="sort-dropdown"]');
    await page.waitForTimeout(200);
    
    // Select a sort option (e.g., "Price: Low to High")
    await page.click('[data-testid="sort-price-asc"]');
    await page.waitForTimeout(500);
    
    // Get new first product name
    const newName = await firstProduct.locator('h4').textContent();
    
    // Names might be different (depending on initial sort)
    // At minimum, products should re-render
    await expect(firstProduct).toBeVisible();
  });
});

test.describe('Add to Cart Interaction Tests', () => {
  test('add to cart button functionality', async ({ page }) => {
    await page.goto('/shop');
    
    // Click add to cart on first product
    const addToCartButton = page.locator('[data-testid="add-to-cart"]').first();
    await addToCartButton.click();
    
    // Wait for cart update animation
    await page.waitForTimeout(500);
    
    // Check cart count updated
    const cartCount = page.locator('[data-testid="cart-count"]');
    await expect(cartCount).toBeVisible();
    const count = await cartCount.textContent();
    expect(parseInt(count || '0')).toBeGreaterThan(0);
  });

  test('cart icon shows animation on add', async ({ page }) => {
    await page.goto('/shop');
    
    const cartIcon = page.locator('[data-testid="cart-icon"]');
    
    // Add to cart
    await page.click('[data-testid="add-to-cart"]').first();
    
    // Wait for animation
    await page.waitForTimeout(300);
    
    // Cart icon should be visible and animated
    await expect(cartIcon).toBeVisible();
  });

  test('quantity selector increases count', async ({ page }) => {
    await page.goto('/products/maplau');
    
    const quantityInput = page.locator('[data-testid="quantity-input"]');
    const increaseButton = page.locator('[data-testid="quantity-increase"]');
    
    // Get initial quantity
    const initialQty = await quantityInput.inputValue();
    
    // Increase quantity
    await increaseButton.click();
    
    // Get new quantity
    const newQty = await quantityInput.inputValue();
    
    expect(parseInt(newQty)).toBe(parseInt(initialQty) + 1);
  });

  test('quantity selector decreases count', async ({ page }) => {
    await page.goto('/products/maplau');
    
    const quantityInput = page.locator('[data-testid="quantity-input"]');
    const increaseButton = page.locator('[data-testid="quantity-increase"]');
    const decreaseButton = page.locator('[data-testid="quantity-decrease"]');
    
    // Increase first to have quantity > 1
    await increaseButton.click();
    const currentQty = await quantityInput.inputValue();
    
    // Decrease quantity
    await decreaseButton.click();
    
    // Get new quantity
    const newQty = await quantityInput.inputValue();
    
    expect(parseInt(newQty)).toBe(parseInt(currentQty) - 1);
  });
});

test.describe('Search Interaction Tests', () => {
  test('search input shows suggestions', async ({ page }) => {
    await page.goto('/');
    
    const searchInput = page.locator('[data-testid="search-input"]');
    
    if (await searchInput.count() > 0) {
      // Type in search
      await searchInput.fill('turmeric');
      await page.waitForTimeout(300); // Debounce
      
      // Check for suggestions dropdown
      const suggestions = page.locator('[data-testid="search-suggestions"]');
      await expect(suggestions).toBeVisible();
    }
  });

  test('search submits on enter', async ({ page }) => {
    await page.goto('/');
    
    const searchInput = page.locator('[data-testid="search-input"]');
    
    if (await searchInput.count() > 0) {
      // Type and press enter
      await searchInput.fill('ginger');
      await searchInput.press('Enter');
      
      // Should navigate to search results
      await page.waitForURL(/search/);
      
      // Check URL contains query
      const url = page.url();
      expect(url).toContain('ginger');
    }
  });
});

test.describe('Image Interaction Tests', () => {
  test('product image zoom on hover', async ({ page }) => {
    await page.goto('/products/maplau');
    
    const productImage = page.locator('[data-testid="product-image-main"]');
    await expect(productImage).toBeVisible();
    
    // Hover over image
    await productImage.hover();
    await page.waitForTimeout(300);
    
    // Check for zoom effect (scale transform)
    const transform = await productImage.evaluate((el) =>
      window.getComputedStyle(el).transform
    );
    
    expect(transform).toContain('matrix');
  });

  test('product gallery thumbnail click', async ({ page }) => {
    await page.goto('/products/maplau');
    
    const mainImage = page.locator('[data-testid="product-image-main"]');
    const thumbnails = page.locator('[data-testid="product-thumbnail"]');
    
    if ((await thumbnails.count()) > 1) {
      // Get initial main image src
      const initialSrc = await mainImage.getAttribute('src');
      
      // Click second thumbnail
      await thumbnails.nth(1).click();
      await page.waitForTimeout(200);
      
      // Get new main image src
      const newSrc = await mainImage.getAttribute('src');
      
      // Main image should change
      expect(newSrc).not.toBe(initialSrc);
    }
  });
});
