#!/bin/bash
echo "🚀 Starting Hugo development server..."
echo "📝 Including draft posts"
echo "🌐 Server will be available at http://localhost:1313"
echo ""
hugo server -D --bind 0.0.0.0 --disableFastRender
