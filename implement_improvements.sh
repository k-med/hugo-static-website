#!/bin/bash
# Implementation Script for KDOS Site Improvements
# Run this to apply the new structure and configuration

set -e

echo "🚀 Implementing KDOS site improvements..."
echo "========================================"

# Backup current state
echo "📦 Creating backup..."
cp hugo.toml hugo.toml.backup
cp -r content content.backup

# Step 1: Create new content structure
echo "📁 Creating new content directories..."
mkdir -p content/essays
mkdir -p content/guides  
mkdir -p content/notes
# Projects already exists

# Step 2: Create section index files
echo "📝 Creating section index pages..."

cat > content/essays/_index.md << 'EOF'
---
title: "Essays"
description: "Long-form writing on philosophy, civilisation, and the search for meaning"
layout: "list"
---

Structured inquiries into the crisis of modernity and possibilities for renewal. These pieces explore the intersection of moral philosophy, economics, cultural criticism, and lived experience.

### Featured Series

- **[The Modernity Cycle](/series/modernity-cycle/)** — On civilisational decline and restoration
- **[The Civic Virtue Project](/series/civic-virtue-project/)** — Blueprints for community renewal  
- **[Letters from the Collapse](/series/letters-from-the-collapse/)** — Clear-eyed observations with practical antidotes

---

*Browse all essays below or explore by [series](/series/) and [theme](/tags/)*
EOF

cat > content/guides/_index.md << 'EOF'
---
title: "Guides"  
description: "Technical documentation, how-tos, and fieldcraft"
layout: "list"
---

Practical, tested instructions for building sovereignty — digital, economic, and physical. No fluff, no lifestyle marketing. Just what works.

### Areas of Focus

**Digital Sovereignty**  
Linux configurations, privacy tools, self-hosted services, encrypted workflows

**Craft & Trade**  
Tool selection, workshop setup, traditional skills, small business operations

**Nomadic Fieldcraft**  
Working holiday visas, seasonal work, language learning, sustainable travel

---

*Each guide includes context, detailed steps, and lessons learned*
EOF

cat > content/notes/_index.md << 'EOF'
---
title: "Notes"
description: "Short reflections, observations, and working thoughts"
layout: "list"
---

Brief pieces that don't require the scaffolding of an essay — meditations, field observations, reading notes, and experiments in progress.

Think of these as open notebook pages: provisional, exploratory, alive.

### Recent Threads

- Stoic practice and daily discipline
- Observations from European cities
- Technical experiments and micro-projects
- Quotes and commentary from ongoing reading

---

*Updated frequently, revised occasionally*
EOF

# Step 3: Move content to appropriate sections
echo "🔄 Migrating content..."

# Move essays (including the one in posts/essays)
if [ -f "content/posts/essays/the-collapse-of-non-monetary-value-systems.md" ]; then
    cp content/posts/essays/*.md content/essays/ 2>/dev/null || true
    echo "  ✓ Moved essays"
fi

# Move guides (Linux content)
if [ -d "content/posts/linux" ]; then
    cp content/posts/linux/*.md content/guides/ 2>/dev/null || true
    # Update the type in frontmatter
    for file in content/guides/*.md; do
        if [ -f "$file" ]; then
            sed -i '3a type: "guide"' "$file" 2>/dev/null || true
        fi
    done
    echo "  ✓ Moved guides"
fi

# Move notes (meta and short posts)
if [ -f "content/posts/my-first-post.md" ]; then
    cp content/posts/my-first-post.md content/notes/ 2>/dev/null || true
fi
if [ -d "content/posts/meta" ]; then
    cp content/posts/meta/*.md content/notes/ 2>/dev/null || true
    echo "  ✓ Moved notes"
fi

# Step 4: Create archetype files
echo "📋 Creating archetypes..."
mkdir -p archetypes

cat > archetypes/essay.md << 'ARCHETYPEEOF'
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
type: "essay"
series: []  
topics: []  
tags: []
summary: ""
showToc: true
tocOpen: false
readingTime: true
---

## Introduction

## Part I: [Context]

## Part II: [Analysis]  

## Part III: [Implications]

## Conclusion
ARCHETYPEEOF

cat > archetypes/guide.md << 'ARCHETYPEEOF'
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
type: "guide"
category: ""
tools: []
difficulty: ""
tags: []
summary: ""
showToc: true
tocOpen: true
---

## Prerequisites

## Overview

## Step 1: [Action]

## Step 2: [Action]

## Verification

## Troubleshooting
ARCHETYPEEOF

cat > archetypes/note.md << 'ARCHETYPEEOF'
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
type: "note"
noteType: ""
tags: []
---

[Thought or observation]
ARCHETYPEEOF

echo "  ✓ Created archetypes"

# Step 5: Create custom CSS directory
echo "🎨 Setting up custom styles..."
mkdir -p static/css
# Copy the custom.css file here if you want to apply it

# Step 6: Update hugo.toml
echo "⚙️ Updating Hugo configuration..."
# Backup is already created, so we can safely update

cat > hugo.toml << 'HUGOEOF'
baseURL = 'https://kdos.xyz/'
languageCode = 'en-us'
title = 'KDOS'
theme = 'PaperMod'

enableRobotsTXT = true
buildDrafts = false
buildFuture = false
buildExpired = false
enableEmoji = true
paginate = 12

[taxonomies]
  category = "categories"
  tag = "tags"
  series = "series"

[params]
  env = "production"
  description = "Field notes on craft, code, and the examined life"
  author = "KDOS"
  
  defaultTheme = "auto"
  disableThemeToggle = false
  ShowReadingTime = true
  ShowShareButtons = false
  ShowPostNavLinks = true
  ShowBreadCrumbs = true
  ShowCodeCopyButtons = true
  ShowWordCount = false
  ShowRssButtonInSectionTermList = true
  UseHugoToc = true
  disableSpecial1stPost = false
  disableScrollToTop = false
  comments = false
  hidemeta = false
  hideSummary = false
  showtoc = true
  tocopen = false
  
  # Custom CSS if you added the file
  # customCSS = ["css/custom.css"]
  
  [params.homeInfoParams]
    Title = "KDOS"
    Content = """
Systems, philosophy, and craftsmanship for a post-industrial life.
    
**[Essays](/essays/)** on civilisation and meaning / **[Projects](/projects/)** built and documented /
**[Guides](/guides/)** for sovereignty and skill / **[Notes](/notes/)** on the examined life
    """

  [[params.socialIcons]]
    name = "github"
    url = "https://github.com/k-med"

  [[params.socialIcons]]
    name = "rss"
    url = "/index.xml"

[menu]
  [[menu.main]]
    name = "Essays"
    url = "/essays/"
    weight = 1

  [[menu.main]]
    name = "Projects"
    url = "/projects/"
    weight = 2

  [[menu.main]]
    name = "Guides"
    url = "/guides/"
    weight = 3

  [[menu.main]]
    name = "Notes"
    url = "/notes/"
    weight = 4

  [[menu.main]]
    name = "About"
    url = "/about/"
    weight = 5

[[menu.footer]]
  name = "Series"
  url = "/series/"
  weight = 1

[[menu.footer]]
  name = "Archives"
  url = "/archives/"
  weight = 2

[[menu.footer]]
  name = "Search"
  url = "/search/"
  weight = 4

[outputs]
  home = ["HTML", "RSS", "JSON"]
  section = ["HTML", "RSS"]

[markup]
  [markup.highlight]
    anchorLineNos = false
    codeFences = true
    guessSyntax = true
    lineNos = false
    noClasses = false
    style = "monokai"
  [markup.goldmark]
    [markup.goldmark.renderer]
      unsafe = true
HUGOEOF

echo "  ✓ Configuration updated"

# Step 7: Update About page
echo "📄 Updating About page..."
if [ -f "content/about/_index.md" ]; then
    cp about_improved.md content/about/_index.md 2>/dev/null || echo "  ! Update About page manually"
fi

echo ""
echo "✅ Implementation complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Review the migrated content in /essays, /guides, /notes"
echo "2. Update frontmatter in existing posts to include 'type' field"
echo "3. Test the site: hugo server -D"
echo "4. Add custom.css to static/css/ if desired"
echo "5. Commit changes when satisfied"
echo ""
echo "Backups created:"
echo "  - hugo.toml.backup"
echo "  - content.backup/"
echo ""
echo "To create new content:"
echo "  hugo new --kind essay essays/my-essay.md"
echo "  hugo new --kind guide guides/my-guide.md"
echo "  hugo new --kind note notes/my-note.md"
