#!/bin/bash

# Kantan CMS Build Script (Simplified)
# This script:
# 1. Fetches data from Kantan CMS and converts to markdown (single step)
# 2. Builds the Astro site

set -e  # Exit on error

echo "====================================================="
echo "🚀 Starting Kantan CMS build process"
echo "====================================================="
echo

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found"
    echo "Please create a .env file with the following variables:"
    echo "  KANTAN_PROJECT_ID=your-project-id"
    echo "  KANTAN_API_KEY=your-api-key"
    echo "  KANTAN_BASE_URL=https://api.kantan-cms.com (optional)"
    echo "  KANTAN_REQUIRED_COLLECTION_IDS=collection-id-1,collection-id-2 (optional)"
    exit 1
fi

# Load environment variables
source .env

# Validate required environment variables
if [ -z "$KANTAN_PROJECT_ID" ] && [ -z "$PROJECT_ID" ]; then
    echo "❌ Error: KANTAN_PROJECT_ID (or PROJECT_ID) not set in .env"
    exit 1
fi

if [ -z "$KANTAN_API_KEY" ] && [ -z "$CMS_API_KEY" ]; then
    echo "❌ Error: KANTAN_API_KEY (or CMS_API_KEY) not set in .env"
    exit 1
fi

echo "✅ Environment variables loaded"
echo

# Step 1: Fetch and convert content
echo "📥 Step 1/2: Fetching and converting content from Kantan CMS..."
echo

bash scripts/get-from-cms.sh && bash scripts/run-convert.sh

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to fetch and convert content"
    exit 1
fi

echo
echo "✅ Content fetching and conversion completed successfully"
echo

# Step 2: Build the site
echo "🏗️ Step 2/2: Building the site with npm..."
echo

npm run build

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to build the site"
    exit 1
fi

echo
echo "✅ Site build completed successfully"
echo

echo "====================================================="
echo "✨ Build process completed successfully!"
echo "====================================================="
echo
echo "📋 Summary:"
echo "  - Content fetched from Kantan CMS"
echo "  - Markdown files generated in src/content/blog/ directory"
echo "  - Astro site built successfully"
echo
echo "🚀 Your site is ready to deploy!"
echo "====================================================="
