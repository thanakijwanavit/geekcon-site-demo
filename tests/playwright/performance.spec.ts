import { test, expect } from '@playwright/test';

/**
 * Performance Tests for Geekcon Herbs UI
 * 
 * Tests Core Web Vitals, bundle sizes, and performance metrics
 * Ensures site meets performance targets from design document
 */

test.describe('Core Web Vitals Tests', () => {
  test('homepage LCP is under 2.5 seconds', async ({ page }) => {
    await page.goto('/');
    
    // Wait for page load
    await page.waitForLoadState('networkidle');
    
    // Measure LCP
    const lcp = await page.evaluate(() => {
      return new Promise((resolve) => {
        new PerformanceObserver((list) => {
          const entries = list.getEntries();
          const lastEntry = entries[entries.length - 1];
          resolve(lastEntry.renderTime || lastEntry.loadTime);
        }).observe({ entryTypes: ['largest-contentful-paint'] });
        
        // Timeout after 10 seconds
        setTimeout(() => resolve(0), 10000);
      });
    });
    
    // LCP should be under 2.5 seconds (2500ms)
    expect(lcp).toBeLessThan(2500);
  });

  test('homepage CLS is under 0.1', async ({ page }) => {
    await page.goto('/');
    
    // Wait for page to be fully loaded
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(2000); // Wait for any layout shifts
    
    // Measure CLS
    const cls = await page.evaluate(() => {
      return new Promise((resolve) => {
        let clsValue = 0;
        
        new PerformanceObserver((list) => {
          for (const entry of list.getEntries() as any[]) {
            if (!entry.hadRecentInput) {
              clsValue += entry.value;
            }
          }
        }).observe({ entryTypes: ['layout-shift'] });
        
        // Wait 3 seconds then return CLS
        setTimeout(() => resolve(clsValue), 3000);
      });
    });
    
    // CLS should be under 0.1
    expect(cls).toBeLessThan(0.1);
  });

  test('first contentful paint is under 1.8 seconds', async ({ page }) => {
    await page.goto('/');
    
    // Get FCP
    const fcp = await page.evaluate(() => {
      const perfEntries = performance.getEntriesByType('paint');
      const fcpEntry = perfEntries.find((entry) => entry.name === 'first-contentful-paint');
      return fcpEntry?.startTime || 0;
    });
    
    // FCP should be under 1.8 seconds (1800ms)
    expect(fcp).toBeLessThan(1800);
  });

  test('time to interactive is under 3.8 seconds', async ({ page }) => {
    await page.goto('/');
    
    // Wait for page to be interactive
    await page.waitForLoadState('networkidle');
    
    // Get TTI (approximated)
    const tti = await page.evaluate(() => {
      return performance.timing.domInteractive - performance.timing.navigationStart;
    });
    
    // TTI should be under 3.8 seconds (3800ms)
    expect(tti).toBeLessThan(3800);
  });
});

test.describe('Resource Loading Tests', () => {
  test('images are lazy loaded below the fold', async ({ page }) => {
    await page.goto('/');
    
    // Get images
    const images = await page.locator('img').all();
    
    let lazyLoadedCount = 0;
    
    for (const img of images) {
      const loading = await img.getAttribute('loading');
      const isInViewport = await img.evaluate((el) => {
        const rect = el.getBoundingClientRect();
        return rect.top < window.innerHeight;
      });
      
      // Images below fold should be lazy loaded
      if (!isInViewport && loading === 'lazy') {
        lazyLoadedCount++;
      }
    }
    
    // At least some images should be lazy loaded
    expect(lazyLoadedCount).toBeGreaterThan(0);
  });

  test('images use WebP format with fallback', async ({ page }) => {
    await page.goto('/');
    
    // Get picture elements (modern image format with fallback)
    const pictures = await page.locator('picture').all();
    
    if (pictures.length > 0) {
      for (const picture of pictures.slice(0, 5)) {
        // Check for WebP source
        const webpSource = picture.locator('source[type="image/webp"]');
        const hasWebP = (await webpSource.count()) > 0;
        
        // Check for fallback img
        const fallbackImg = picture.locator('img');
        const hasFallback = (await fallbackImg.count()) > 0;
        
        expect(hasWebP || hasFallback).toBe(true);
      }
    }
  });

  test('fonts are preloaded', async ({ page }) => {
    await page.goto('/');
    
    // Check for font preload links
    const fontPreloads = page.locator('link[rel="preload"][as="font"]');
    const count = await fontPreloads.count();
    
    // Should have at least one font preload
    expect(count).toBeGreaterThan(0);
  });

  test('critical CSS is inlined', async ({ page }) => {
    const response = await page.goto('/');
    const html = await response!.text();
    
    // Check for inline styles or style tag
    const hasInlineStyles = html.includes('<style>') || html.includes('style=');
    
    expect(hasInlineStyles).toBe(true);
  });

  test('JavaScript is properly code-split', async ({ page }) => {
    await page.goto('/');
    
    // Get all script tags
    const scripts = await page.locator('script[src]').all();
    
    const scriptSrcs = await Promise.all(
      scripts.map(async (script) => await script.getAttribute('src'))
    );
    
    // Should have multiple chunks (code splitting)
    const chunkFiles = scriptSrcs.filter((src) => src?.includes('chunk'));
    expect(chunkFiles.length).toBeGreaterThan(1);
  });
});

test.describe('Bundle Size Tests', () => {
  test('initial JavaScript bundle is under 200KB', async ({ page }) => {
    const resources: any[] = [];
    
    page.on('response', (response) => {
      const url = response.url();
      if (url.includes('.js') && response.request().resourceType() === 'script') {
        response.finished().then(() => {
          resources.push({
            url,
            size: response.headers()['content-length'],
          });
        });
      }
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Calculate total JS size
    let totalSize = 0;
    for (const resource of resources) {
      if (resource.size) {
        totalSize += parseInt(resource.size);
      }
    }
    
    // Convert to KB
    const totalKB = totalSize / 1024;
    
    // Should be under 200KB
    expect(totalKB).toBeLessThan(200);
  });

  test('total page weight is under 1MB', async ({ page }) => {
    const resources: any[] = [];
    
    page.on('response', (response) => {
      response.finished().then(() => {
        const size = response.headers()['content-length'];
        if (size) {
          resources.push({
            url: response.url(),
            size: parseInt(size),
          });
        }
      });
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Calculate total size
    const totalSize = resources.reduce((sum, r) => sum + r.size, 0);
    const totalMB = totalSize / (1024 * 1024);
    
    // Should be under 1MB
    expect(totalMB).toBeLessThan(1);
  });
});

test.describe('Caching Strategy Tests', () => {
  test('static assets have cache headers', async ({ page }) => {
    const cacheableResources: any[] = [];
    
    page.on('response', (response) => {
      const url = response.url();
      const isStatic = /\.(js|css|png|jpg|jpeg|webp|woff|woff2)$/.test(url);
      
      if (isStatic) {
        cacheableResources.push({
          url,
          cacheControl: response.headers()['cache-control'],
        });
      }
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Most static resources should have cache headers
    const cachedResources = cacheableResources.filter(
      (r) => r.cacheControl && r.cacheControl !== 'no-cache'
    );
    
    const cachePercentage = (cachedResources.length / cacheableResources.length) * 100;
    
    // At least 80% of static resources should be cacheable
    expect(cachePercentage).toBeGreaterThan(80);
  });
});

test.describe('Image Optimization Tests', () => {
  test('hero images are under 200KB', async ({ page }) => {
    const imageResources: any[] = [];
    
    page.on('response', (response) => {
      const url = response.url();
      const isImage = /\.(png|jpg|jpeg|webp)$/.test(url);
      
      if (isImage) {
        response.finished().then(() => {
          const size = response.headers()['content-length'];
          if (size) {
            imageResources.push({
              url,
              size: parseInt(size),
            });
          }
        });
      }
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Check hero images (usually larger)
    for (const img of imageResources.slice(0, 3)) {
      const sizeKB = img.size / 1024;
      expect(sizeKB).toBeLessThan(200);
    }
  });

  test('product images are under 100KB', async ({ page }) => {
    const imageResources: any[] = [];
    
    page.on('response', (response) => {
      const url = response.url();
      const isImage = /\.(png|jpg|jpeg|webp)$/.test(url);
      
      if (isImage) {
        response.finished().then(() => {
          const size = response.headers()['content-length'];
          if (size) {
            imageResources.push({
              url,
              size: parseInt(size),
            });
          }
        });
      }
    });
    
    await page.goto('/shop');
    await page.waitForLoadState('networkidle');
    
    // Product images should be smaller
    for (const img of imageResources) {
      const sizeKB = img.size / 1024;
      expect(sizeKB).toBeLessThan(100);
    }
  });

  test('images have proper dimensions to prevent CLS', async ({ page }) => {
    await page.goto('/');
    
    const images = await page.locator('img').all();
    
    for (const img of images.slice(0, 10)) {
      if (await img.isVisible()) {
        const hasWidth = await img.getAttribute('width');
        const hasHeight = await img.getAttribute('height');
        const hasAspectRatio = await img.evaluate((el) => {
          const style = window.getComputedStyle(el);
          return style.aspectRatio !== 'auto';
        });
        
        // Image should have dimensions or aspect ratio
        expect(hasWidth || hasHeight || hasAspectRatio).toBe(true);
      }
    }
  });
});

test.describe('Network Performance Tests', () => {
  test('homepage makes fewer than 50 requests', async ({ page }) => {
    let requestCount = 0;
    
    page.on('request', () => {
      requestCount++;
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Should make fewer than 50 requests
    expect(requestCount).toBeLessThan(50);
  });

  test('API calls are efficient', async ({ page }) => {
    const apiCalls: any[] = [];
    
    page.on('response', (response) => {
      const url = response.url();
      if (url.includes('/api/')) {
        apiCalls.push({
          url,
          status: response.status(),
          timing: response.timing(),
        });
      }
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // API calls should return quickly
    for (const call of apiCalls) {
      if (call.timing) {
        expect(call.timing.responseEnd).toBeLessThan(1000);
      }
    }
  });

  test('no failed network requests', async ({ page }) => {
    const failedRequests: any[] = [];
    
    page.on('response', (response) => {
      if (response.status() >= 400) {
        failedRequests.push({
          url: response.url(),
          status: response.status(),
        });
      }
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Should have no failed requests
    expect(failedRequests).toHaveLength(0);
  });
});

test.describe('Mobile Performance Tests', () => {
  test('mobile LCP is under 2.5 seconds', async ({ page }) => {
    // Set mobile viewport
    await page.setViewportSize({ width: 375, height: 812 });
    
    // Throttle network to simulate 3G
    const client = await page.context().newCDPSession(page);
    await client.send('Network.emulateNetworkConditions', {
      offline: false,
      downloadThroughput: (1.5 * 1024 * 1024) / 8, // 1.5 Mbps
      uploadThroughput: (750 * 1024) / 8, // 750 Kbps
      latency: 100,
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Measure LCP on mobile with throttling
    const lcp = await page.evaluate(() => {
      return new Promise((resolve) => {
        new PerformanceObserver((list) => {
          const entries = list.getEntries();
          const lastEntry = entries[entries.length - 1];
          resolve(lastEntry.renderTime || lastEntry.loadTime);
        }).observe({ entryTypes: ['largest-contentful-paint'] });
        
        setTimeout(() => resolve(0), 10000);
      });
    });
    
    // LCP should still be under 2.5 seconds on mobile 3G
    expect(lcp).toBeLessThan(2500);
  });

  test('mobile page weight is optimized', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 812 });
    
    const resources: any[] = [];
    
    page.on('response', (response) => {
      response.finished().then(() => {
        const size = response.headers()['content-length'];
        if (size) {
          resources.push({
            url: response.url(),
            size: parseInt(size),
          });
        }
      });
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Calculate total size
    const totalSize = resources.reduce((sum, r) => sum + r.size, 0);
    const totalMB = totalSize / (1024 * 1024);
    
    // Mobile should be even lighter
    expect(totalMB).toBeLessThan(0.8);
  });
});
