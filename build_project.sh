#!/bin/bash

set -e

echo "🔥 Building Rumble Loadouts..."

# Use npm build process which includes Service Worker
echo "📦 Running npm build..."
npm run build

echo "✅ Build complete! Files are in dist/"