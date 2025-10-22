#!/bin/bash
# migrate-content.sh - Consolidate blog posts into /posts/

set -e

echo "🔄 Starting content migration..."

# Create posts subdirectories
mkdir -p content/posts/linux
mkdir -p content/posts/essays
mkdir -p content/posts/meta

# Move /blog/ content to /posts/
echo "📦 Moving blog posts..."
if [ -d "content/blog" ]; then
    # Linux posts
    [ -f "content/blog/hyprland-install-guide.md" ] && mv content/blog/hyprland-install-guide.md content/posts/linux/
    
    # Essays
    [ -f "content/blog/the-collapse-of-non-monetary-value-systems.md" ] && mv content/blog/the-collapse-of-non-monetary-value-systems.md content/posts/essays/
    
    # Meta posts
    [ -f "content/blog/getting-started.md" ] && mv content/blog/getting-started.md content/posts/meta/
    [ -f "content/blog/post-title.md" ] && mv content/blog/post-title.md content/posts/meta/
    
    # Remove empty blog directory
    rmdir content/blog 2>/dev/null || echo "⚠️  blog directory not empty, check manually"
fi

# Create _index.md files
echo "📝 Creating index files..."

cat > content/posts/_index.md << 'EOF'
---
title: "Writing"
layout: "list"
url: "/posts/"
summary: "Essays, guides, and field notes"
---

## Writing

Collected thoughts organized by [series](/series/), searchable by [tag](/tags/), and archived [chronologically](/archives/).

Some writing is structured inquiry — essays in **[The Modernity Cycle](/series/modernity-cycle/)** or blueprints in **[The Civic Virtue Project](/series/civic-virtue-project/)**. Other posts are tactical: Linux configs, tool reviews, or workflow documentation.

Everything here assumes the reader wants substance over noise.
EOF

cat > content/projects/_index.md << 'EOF'
---
title: "Projects"
layout: "list"
url: "/projects/"
summary: "Case studies and real-world builds"
---

## Projects

Documentation of actual things built, fixed, or improved — with outcomes, costs, and lessons learned.

Not speculation or theory. These are reports from completed work:
- Physical systems (gardens, structures, tools)
- Community initiatives (time banks, skill-shares, mutual aid networks)
- Technical builds (self-hosted services, automation, privacy infrastructure)

Each project includes:
- **Context**: Why this mattered
- **Process**: What was done, in what order
- **Result**: What worked, what failed, what's worth repeating
EOF

# Clean up public directory
echo "🧹 Cleaning public directory..."
rm -rf public/*

# Rebuild site
echo "🔨 Rebuilding site..."
hugo

echo "✅ Migration complete!"
echo ""
echo "Next steps:"
echo "1. Review moved files in content/posts/"
echo "2. Update hugo.toml menu (see hugo_toml_menu artifact)"
echo "3. Test with: hugo server -D"
echo "4. Commit changes when satisfied"
