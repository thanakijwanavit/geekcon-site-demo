#!/bin/bash

###############################################################################
# Setup Script for Geekcon Herbs Development Environment
# 
# Initializes the development environment with all required dependencies
###############################################################################

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[SETUP]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo "=========================================="
echo "Geekcon Herbs Development Setup"
echo "=========================================="
echo ""

# Check Node.js version
log_info "Checking Node.js version..."
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
    log_warning "Node.js version should be >= 20.0.0. Current: $(node -v)"
    log_warning "Please upgrade Node.js: https://nodejs.org/"
fi

# Install dependencies
log_info "Installing npm dependencies..."
npm install

# Install Playwright browsers
log_info "Installing Playwright browsers..."
npx playwright install --with-deps

# Create .env.local if it doesn't exist
if [ ! -f ".env.local" ]; then
    log_info "Creating .env.local file..."
    cat > .env.local <<EOF
# Geekcon Herbs Environment Variables
NODE_ENV=development
PORT=3000

# AWS Configuration (using aws-sdk default credentials)
AWS_REGION=us-west-2

# DynamoDB
DYNAMODB_TABLE_PREFIX=geekcon-dev

# Application URLs
NEXT_PUBLIC_API_URL=http://localhost:3000/api
NEXT_PUBLIC_SITE_URL=http://localhost:3000

# Feature Flags
NEXT_PUBLIC_ENABLE_ANALYTICS=false
EOF
    log_success ".env.local created"
else
    log_info ".env.local already exists"
fi

# Setup git hooks
if [ -d ".git" ]; then
    log_info "Setting up git hooks..."
    npx husky install
    npx husky add .husky/pre-commit "npx lint-staged"
    log_success "Git hooks configured"
fi

# Create test results directory
mkdir -p test-results

# Create logs directory
mkdir -p logs

# Setup complete
echo ""
log_success "=========================================="
log_success "Setup completed successfully!"
log_success "=========================================="
echo ""
echo "Next steps:"
echo "  1. Review .env.local and configure if needed"
echo "  2. Start development server: npm run dev"
echo "  3. Run tests: npm run test:e2e"
echo ""
echo "For more information, see:"
echo "  - README.md"
echo "  - DESIGN_DOCUMENT.md"
echo "  - MEOW_WORKFLOW.md"
echo ""
