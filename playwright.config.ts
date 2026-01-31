import { defineConfig, devices } from '@playwright/test';

/**
 * Playwright Configuration for Geekcon Herbs
 * 
 * Configured for MCP integration and comprehensive UI testing
 * Follows MEOW principle - Observable through detailed test reporting
 */

export default defineConfig({
  // Test directory
  testDir: './tests/playwright',
  
  // Maximum time one test can run
  timeout: 30 * 1000,
  
  // Test execution
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  
  // Reporter configuration
  reporter: [
    ['html', { outputFolder: 'test-results/html' }],
    ['json', { outputFile: 'test-results/results.json' }],
    ['junit', { outputFile: 'test-results/junit.xml' }],
    ['list'],
  ],
  
  // Global configuration
  use: {
    // Base URL for testing
    baseURL: process.env.TEST_URL || 'http://localhost:3000',
    
    // Browser options
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    
    // Navigation timeout
    navigationTimeout: 30000,
    actionTimeout: 10000,
  },

  // Projects - Multiple browsers and devices
  projects: [
    // Desktop browsers
    {
      name: 'chromium-desktop',
      use: {
        ...devices['Desktop Chrome'],
        viewport: { width: 1440, height: 900 },
      },
    },
    {
      name: 'firefox-desktop',
      use: {
        ...devices['Desktop Firefox'],
        viewport: { width: 1440, height: 900 },
      },
    },
    {
      name: 'webkit-desktop',
      use: {
        ...devices['Desktop Safari'],
        viewport: { width: 1440, height: 900 },
      },
    },

    // Tablet
    {
      name: 'tablet-ipad',
      use: {
        ...devices['iPad Pro'],
      },
    },

    // Mobile devices
    {
      name: 'mobile-iphone-14',
      use: {
        ...devices['iPhone 14'],
      },
    },
    {
      name: 'mobile-iphone-14-pro',
      use: {
        ...devices['iPhone 14 Pro'],
      },
    },
    {
      name: 'mobile-pixel-7',
      use: {
        ...devices['Pixel 7'],
      },
    },

    // Additional viewports for responsive testing
    {
      name: 'mobile-small',
      use: {
        ...devices['iPhone SE'],
      },
    },
    {
      name: 'desktop-wide',
      use: {
        ...devices['Desktop Chrome'],
        viewport: { width: 1920, height: 1080 },
      },
    },
  ],

  // Web server for local testing
  webServer: process.env.CI ? undefined : {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000,
  },

  // Output directory
  outputDir: 'test-results/artifacts',

  // Expect configuration
  expect: {
    timeout: 5000,
    toHaveScreenshot: {
      // Allow small pixel differences
      maxDiffPixels: 100,
      threshold: 0.2,
    },
  },
});
