#!/bin/bash

set -e

echo "🔥 Building Rumble Loadouts..."

# Clean and create dist directory
rm -rf dist
mkdir -p dist

# Compile Elm
echo "📦 Compiling Elm..."
elm make src/Main.elm --output=dist/elm.js --optimize

# Copy HTML
echo "📄 Copying assets..."
cp index.html dist/

echo "✅ Build complete! Files are in dist/"