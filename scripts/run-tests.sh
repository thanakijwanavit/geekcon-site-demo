#!/bin/bash

###############################################################################
# Playwright MCP Test Runner
# 
# Integrates with Playwright MCP server for automated UI testing
# Runs comprehensive test suites and reports results
###############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
TEST_URL="${TEST_URL:-http://localhost:3000}"
ENVIRONMENT="${ENVIRONMENT:-development}"
HEADLESS="${HEADLESS:-true}"

log_info() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

log_error() {
    echo -e "${RED}[FAIL]${NC} $1"
}

log_info "=========================================="
log_info "Playwright MCP Test Suite"
log_info "Environment: $ENVIRONMENT"
log_info "Test URL: $TEST_URL"
log_info "=========================================="
echo ""

# Export test URL
export TEST_URL

# Run different test suites
run_suite() {
    local suite=$1
    local description=$2
    
    log_info "Running $description..."
    
    if npx playwright test "$suite" --config=playwright.config.ts; then
        log_success "$description passed"
        return 0
    else
        log_error "$description failed"
        return 1
    fi
}

# Track failures
FAILED=0

# Visual Regression Tests
run_suite "tests/playwright/visual-regression.spec.ts" "Visual Regression Tests" || FAILED=$((FAILED+1))
echo ""

# Interaction Tests
run_suite "tests/playwright/interaction.spec.ts" "Interaction Tests" || FAILED=$((FAILED+1))
echo ""

# Accessibility Tests
run_suite "tests/playwright/accessibility.spec.ts" "Accessibility Tests" || FAILED=$((FAILED+1))
echo ""

# Performance Tests
run_suite "tests/playwright/performance.spec.ts" "Performance Tests" || FAILED=$((FAILED+1))
echo ""

# Generate report
log_info "Generating test report..."
npx playwright show-report test-results/html

# Summary
echo ""
log_info "=========================================="
if [ $FAILED -eq 0 ]; then
    log_success "All test suites passed!"
    log_info "=========================================="
    exit 0
else
    log_error "$FAILED test suite(s) failed"
    log_info "=========================================="
    exit 1
fi
