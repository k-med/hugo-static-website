# KDOS - Hugo Site Management Guide

A practical guide to managing your Hugo-powered blog with PaperMod theme.

---

## 📁 How Hugo Organizes Content

**Critical Concept**: Hugo uses **directory location** to determine content type, not a `type:` field in frontmatter.

```
content/
├── essays/         # Files here become "essays" (section: essays)
├── guides/         # Files here become "guides" (section: guides)
├── notes/          # Files here become "notes" (section: notes)
├── projects/       # Files here become "projects" (section: projects)
├── posts/          # Legacy location (being migrated)
│   ├── linux/      # Currently some guides live here
│   ├── essays/     # Currently some essays live here
│   └── meta/       # Currently some notes live here
├── series/         # Series landing pages
├── about/          # About page
├── archives/       # Auto-generated archive
└── search/         # Auto-generated search
```

**The URL structure follows the directory structure:**
- `content/essays/my-essay.md` → `/essays/my-essay/`
- `content/guides/hyprland.md` → `/guides/hyprland/`
- `content/notes/thought.md` → `/notes/thought/`

---

## 🆕 Creating New Content

### Essays
```bash
hugo new essays/my-new-essay.md
```

### Guides
```bash
hugo new guides/my-new-guide.md
```

### Notes
```bash
hugo new notes/my-quick-thought.md
```

### Projects
```bash
hugo new projects/my-build-log.md
```

### Using Archetypes (Optional)
```bash
# Use a series-specific template
hugo new --kind modernity-cycle essays/new-essay.md
hugo new --kind linux-frontier guides/new-guide.md
```

**All new content starts as `draft: true`**. Preview drafts:
```bash
hugo server -D
```

---

## 📝 Understanding Frontmatter

Here's what actually matters in your frontmatter:

```yaml
---
title: "Your Post Title"
subtitle: "Optional subtitle"           # Used in some templates
description: "SEO description"          # Used in meta tags
date: 2025-10-22
draft: false                            # Set to false to publish

series: ["The Modernity Cycle"]         # Links to series pages
categories: ["Philosophy", "Linux"]     # Broad groupings
tags: ["Stoicism", "Arch"]             # Specific topics

summary: "Brief description"            # Shown in post lists
showToc: true                          # Show table of contents
tocopen: false                         # Start with TOC collapsed

# Optional cover image
# cover:
#   image: "/images/my-cover.jpg"
#   alt: "Alt text for accessibility"
#   caption: "Caption shown below image"
---
```

### Cover Images Explained

The `cover:` section adds a featured image to your post:

```yaml
cover:
  image: "/images/series-linux-frontier.jpg"  # Path from static/ directory
  alt: "Descriptive text for screen readers"
  caption: "Text shown below the image"
  relative: false  # Set true if image is in same folder as post
```

**How it works:**
1. Place image in `static/images/` directory
2. Reference it as `/images/filename.jpg` (Hugo strips "static")
3. PaperMod theme displays it at the top of the post
4. Alt text helps accessibility and SEO

**Example file structure:**
```
static/
└── images/
    ├── series-linux-frontier.jpg
    └── series-modernity-cycle.jpg

content/
└── essays/
    └── my-essay.md  # References /images/series-modernity-cycle.jpg
```

---

## 🔄 Moving Content Between Sections

### Example: Move a Post from Essays to Guides

The essay is currently at `content/essays/hyprland-setup.md`

**Step 1: Move the file**
```bash
mv content/essays/hyprland-setup.md content/guides/
```

That's it! The URL automatically changes from `/essays/hyprland-setup/` to `/guides/hyprland-setup/`

**Step 2: Optional cleanup**
Update the frontmatter for consistency (optional but recommended):
```yaml
# You might want to adjust:
description: "A Linux Frontier guide."  # Make it clear it's a guide
summary: "Step-by-step instructions for..."  # Guide-appropriate summary
```

**Step 3: Rebuild**
```bash
rm -rf public/ && hugo
```

### Example: Move from Posts to Essays

Many of your files are currently in `content/posts/essays/`. To move them properly:

```bash
# Move a single file
mv content/posts/essays/the-collapse-of-non-monetary-value-systems.md content/essays/

# Move all essays at once
mv content/posts/essays/*.md content/essays/

# Move all Linux guides to guides section
mv content/posts/linux/*.md content/guides/
```

### Example: Convert a Note to an Essay

```bash
# Move the file
mv content/notes/short-reflection.md content/essays/long-reflection.md

# Edit the frontmatter to expand:
nano content/essays/long-reflection.md
```

Update the frontmatter:
```yaml
# Add a series if appropriate
series: ["Letters from the Collapse"]

# Expand the summary
summary: "A longer, more detailed description fitting for an essay..."

# Consider adding a TOC
showToc: true
```

---

## 📚 Managing Series

### Adding Content to a Series

Series membership is declared in frontmatter, regardless of directory:

```yaml
series: ["The Linux Frontier"]  # Single series

# OR multiple series
series: ["The Linux Frontier", "The Technē Papers"]
```

An essay in `content/essays/` can belong to "The Linux Frontier" series just like a guide in `content/guides/` can.

### Removing from a Series

Delete or comment out the series line:
```yaml
# series: ["The Linux Frontier"]
```

Or use empty array:
```yaml
series: []
```

### Creating a New Series

**Step 1: Create directory and index**
```bash
mkdir -p content/series/my-new-series
nano content/series/my-new-series/_index.md
```

**Step 2: Add the series template**
```yaml
---
title: "My New Series"
subtitle: "A compelling tagline"
description: "What this series explores"
date: 2025-10-22
draft: false
weight: 10  # Lower numbers appear first in series list
layout: "list"
summary: "Brief description for series page"
showToc: false

# Optional cover image for series page
cover:
  image: "/images/series-my-new-series.jpg"
  alt: "Series cover image"
  caption: "Caption for the series"
---

## My New Series

Introduction and overview of what readers will find here.

### Featured Posts
- Link to key posts
- As they get written
```

**Step 3: Create archetype (optional)**
```bash
nano archetypes/my-new-series.md
```

```yaml
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
series: ["My New Series"]
categories: []
tags: []
summary: ""
showToc: true
tocopen: false
---
```

**Step 4: Use it**
```bash
hugo new --kind my-new-series essays/first-post-in-series.md
```

### Deleting a Series

**Step 1: Remove the series directory**
```bash
rm -rf content/series/unwanted-series/
```

**Step 2: Find and update all posts**
```bash
# Find all posts referencing this series
grep -r "Unwanted Series" content/

# Edit each file to remove the series line
# You can do this manually or with sed:
find content/ -name "*.md" -exec sed -i '/Unwanted Series/d' {} +
```

**Step 3: Delete archetype if it exists**
```bash
rm archetypes/unwanted-series.md
```

**Step 4: Rebuild**
```bash
rm -rf public/ && hugo
```

---

## 🏷️ Managing Categories and Tags

Categories and tags work the same regardless of which directory your content is in.

### Modifying Categories/Tags in a Post

```yaml
# Before
categories: ["Philosophy"]
tags: ["Stoicism", "Ethics"]

# After (just edit the frontmatter)
categories: ["Philosophy", "Politics"]
tags: ["Stoicism", "Practice"]
```

### Finding All Uses of a Category/Tag

```bash
# Find all posts with "Linux" category
grep -r "categories.*Linux" content/

# Find all posts with "Hyprland" tag
grep -r "tags.*Hyprland" content/

# Count how many times a tag appears
grep -r "tags.*Privacy" content/ | wc -l
```

### Renaming a Category/Tag Globally

```bash
# Rename "Privacy" to "Digital Privacy" everywhere
find content/ -name "*.md" -type f -exec sed -i 's/"Privacy"/"Digital Privacy"/g' {} +

# Verify changes before committing
git diff

# If it looks good
git add -A
git commit -m "Rename Privacy tag to Digital Privacy"
```

### Bulk Adding a Tag

```bash
# Add "Featured" tag to all essays
# (This is complex - usually better to do manually)

# List what would be affected first
ls content/essays/*.md
```

### Removing Unused Categories/Tags

Hugo automatically generates pages for categories and tags that are actually used. When you remove a category/tag from all posts, its page disappears on the next build. No manual cleanup needed.

**To find potentially unused tags:**
```bash
# See all tags used
grep -r "^tags:" content/ | sed 's/.*tags: //' | tr ',' '\n' | sort | uniq

# Compare with what you expect
```

---

## 🗑️ Deleting Content

### Delete a Single Post

```bash
# Delete the file
rm content/essays/unwanted-post.md

# Rebuild to update site
rm -rf public/ && hugo
```

### Delete Multiple Posts

```bash
# Delete all posts with "draft" in filename
find content/ -name "*draft*.md" -delete

# Delete all drafts (be careful!)
find content/ -name "*.md" -exec grep -l "draft: true" {} \; | xargs rm
```

### Preview What Would Be Deleted

Always preview before bulk deleting:
```bash
# Show drafts that would be deleted
find content/essays/ -name "*.md" -exec grep -l "draft: true" {} \;

# Only after reviewing, actually delete them
find content/essays/ -name "*.md" -exec grep -l "draft: true" {} \; | xargs rm
```

### Archive Instead of Delete

Keep old content without publishing it:

```bash
# Create archive directory if needed
mkdir -p content/archive

# Move post to archive
mv content/essays/old-post.md content/archive/

# Ensure it's marked as draft
# Edit the file and set: draft: true
```

Archived posts with `draft: true` won't appear on the site but remain in version control.

### Delete All Posts in a Category

```bash
# Find posts in a category
grep -l "categories.*Deprecated" content/**/*.md

# Review the list, then delete
grep -l "categories.*Deprecated" content/**/*.md | xargs rm
```

---

## 🔍 Common Maintenance Tasks

### Publishing a Draft

Edit the file:
```yaml
draft: false  # Change from true
```

Save and rebuild:
```bash
hugo
```

### Unpublishing (Make Draft Again)

```yaml
draft: true  # Change from false
```

### Bulk Publish All Drafts in a Section

```bash
# Publish all essays
find content/essays/ -name "*.md" -type f -exec sed -i 's/draft: true/draft: false/g' {} +

# Verify changes
git diff content/essays/

# Rebuild
hugo
```

### Bulk Unpublish (Make Everything Drafts)

```bash
# Make all guides drafts
find content/guides/ -name "*.md" -type f -exec sed -i 's/draft: false/draft: true/g' {} +
```

### Update Dates

Hugo uses ISO 8601 format:
```yaml
date: 2025-10-22                    # Date only
date: 2025-10-22T14:30:00+11:00    # Full timestamp with timezone
```

**Bulk update dates:**
```bash
# Set all essays to today's date (be careful!)
TODAY=$(date +%Y-%m-%d)
find content/essays/ -name "*.md" -exec sed -i "s/^date: .*/date: $TODAY/" {} +
```

### Add Series to Multiple Posts

```bash
# Add "The Modernity Cycle" series to all essays (complex - usually do manually)
# Safer to use a text editor with find/replace or do it manually
```

### Bulk Add a Tag

```bash
# This is tricky with sed - usually better to do manually or with a script
# Example: Add "featured" tag to specific posts

# For posts that already have tags:
# Edit manually or use a proper script
```

---

## 📊 Content Inventory Commands

### Count Posts by Section

```bash
echo "Essays: $(find content/essays/ -name "*.md" | wc -l)"
echo "Guides: $(find content/guides/ -name "*.md" | wc -l)"
echo "Notes: $(find content/notes/ -name "*.md" | wc -l)"
echo "Projects: $(find content/projects/ -name "*.md" | wc -l)"
```

### List All Series Used

```bash
grep -rh "^series:" content/ | sort | uniq
```

### List All Categories

```bash
grep -rh "^categories:" content/ | sed 's/categories: //' | tr -d '[]"' | tr ',' '\n' | sort | uniq
```

### List All Tags

```bash
grep -rh "^tags:" content/ | sed 's/tags: //' | tr -d '[]"' | tr ',' '\n' | sort | uniq
```

### Find Posts Without Series

```bash
# Posts that don't have a series line
find content/{essays,guides,notes}/ -name "*.md" -exec grep -L "^series:" {} \;
```

### Find Drafts

```bash
grep -r "draft: true" content/ | cut -d: -f1
```

### Find Posts Published in Future

```bash
# Posts dated after today
find content/ -name "*.md" -exec grep -l "date: $(date +%Y-%m-%d --date='tomorrow')" {} \;
```

---

## 🚀 Development Workflow

### Start Development Server

```bash
./dev.sh
# OR
hugo server -D --bind 0.0.0.0 --disableFastRender
```

**What the flags mean:**
- `-D` = Show draft posts
- `--bind 0.0.0.0` = Allow access from network (not just localhost)
- `--disableFastRender` = Full rebuild on changes (slower but more reliable)

**Access at:** `http://localhost:1313`

### Clean Build

Remove generated files and rebuild:
```bash
rm -rf public/ resources/ && hugo
```

### Build for Production

```bash
hugo --minify
```

This creates optimized files in `public/` directory.

### Check for Build Errors

```bash
hugo --verbose
```

Shows detailed output including warnings.

---

## 🔧 Site Configuration (hugo.toml)

### Modify Site Title/Description

```toml
title = 'KDOS'
[params]
  description = "Your site description"
  author = "Your Name"
```

### Add/Remove Main Menu Items

```toml
[menu]
  [[menu.main]]
    name = "Essays"      # Text shown in menu
    url = "/essays/"     # Link destination
    weight = 1           # Order (lower = first)

  [[menu.main]]
    name = "Guides"
    url = "/guides/"
    weight = 2
```

### Add Footer Menu Items

```toml
[[menu.footer]]
  name = "Series"
  url = "/series/"
  weight = 1
```

### Change Theme Settings

```toml
[params]
  defaultTheme = "auto"        # Options: light, dark, auto
  ShowReadingTime = true
  ShowShareButtons = false
  ShowPostNavLinks = true
  ShowBreadCrumbs = true
  ShowCodeCopyButtons = true
  ShowWordCount = false
  ShowRssButtonInSectionTermList = true
  
  showtoc = true              # Show TOC by default
  tocopen = false             # Start collapsed
```

### Configure Pagination

```toml
[pagination]
  pagerSize = 12  # Posts per page
```

---

## 🎨 Best Practices

### Content Organization

**Directory = Content Type:**
- Essays → Deep analysis, philosophy → `content/essays/`
- Guides → How-tos, tutorials → `content/guides/`
- Notes → Quick thoughts → `content/notes/`
- Projects → Case studies → `content/projects/`

**Series = Thematic Collections:**
Use series to group related content across different types. An essay and a guide can both be in "The Linux Frontier" series.

**Categories = Broad Topics (3-5 max per post):**
- Philosophy, Linux, Craft, Politics, etc.

**Tags = Specific Keywords (5-10 max per post):**
- Stoicism, Arch, Hyprland, Privacy, Woodworking, etc.

### File Naming

```bash
# Good
my-post-title.md
2025-10-22-my-post.md
linux-privacy-guide.md

# Avoid
My Post Title.md          # Spaces
my_post_title.md          # Underscores work but hyphens are more common
my-post!.md               # Special characters
```

### Frontmatter Consistency

Keep frontmatter in this order for consistency:
```yaml
---
title: "..."
subtitle: "..."           # If used
description: "..."        # If used
date: 2025-10-22
draft: false

series: ["..."]           # If applicable
categories: ["...", "..."]
tags: ["...", "...", "..."]

summary: "..."
showToc: true
tocopen: false

# cover:                  # If used
#   image: "..."
#   alt: "..."
#   caption: "..."
---
```

---

## 🛠️ Troubleshooting

### Post Not Showing Up

**Check these in order:**

1. **Is it a draft?**
   ```bash
   grep "draft:" content/path/to/post.md
   # Should be: draft: false
   ```

2. **Is the date in the future?**
   ```bash
   grep "date:" content/path/to/post.md
   # Compare to today's date
   ```

3. **Is it in the right directory?**
   ```bash
   # Should be in content/essays/, content/guides/, etc.
   # Not in content/archive/ or similar
   ```

4. **Rebuild the site:**
   ```bash
   rm -rf public/ && hugo
   ```

### Series Not Linking Properly

1. **Check series name matches exactly (case-sensitive):**
   ```bash
   # In post:
   series: ["The Linux Frontier"]
   
   # Series directory must be:
   content/series/linux-frontier/
   ```

2. **Ensure _index.md exists:**
   ```bash
   ls content/series/linux-frontier/_index.md
   ```

3. **Rebuild:**
   ```bash
   rm -rf public/ && hugo
   ```

### Changes Not Appearing in Browser

1. **Hard refresh:** Ctrl+Shift+R (Cmd+Shift+R on Mac)
2. **Restart Hugo server:** Stop (Ctrl+C) and restart
3. **Use --disableFastRender:**
   ```bash
   hugo server -D --disableFastRender
   ```

### Broken Links

**Always use absolute paths from site root:**
```markdown
[Link to about](/about/)
[Link to essay](/essays/my-essay/)
[Link to series](/series/modernity-cycle/)
```

**Never use:**
```markdown
[Bad](../about/)              # Relative paths
[Bad](about/)                 # Missing leading slash
[Bad](/about/index.html)      # Including filenames
```

### Build Errors

```bash
# See detailed errors
hugo --verbose

# Common issues:
# - Invalid YAML in frontmatter (check indentation)
# - Missing closing quotes
# - Invalid date format
```

---

## 📦 Deployment

### Automatic Deployment

Site auto-deploys to Cloudflare Pages when you push to `main` branch:

```bash
git add -A
git commit -m "Add new essay on X"
git push origin main
```

Cloudflare automatically runs `hugo` and publishes to production.

### Manual Deployment

```bash
# Build production site
hugo --minify

# The public/ directory contains your site
# Upload it to your hosting provider
```

---

## 🔗 Quick Reference Card

### Creating Content
```bash
hugo new essays/title.md        # New essay
hugo new guides/title.md        # New guide  
hugo new notes/title.md         # New note
hugo server -D                  # Preview with drafts
```

### Moving Content
```bash
mv content/essays/post.md content/guides/    # Essay → Guide
mv content/notes/post.md content/essays/     # Note → Essay
```

### Managing Series
```yaml
series: ["The Linux Frontier"]              # Add to frontmatter
series: []                                   # Remove from frontmatter
```

### Common Searches
```bash
grep -r "draft: true" content/              # Find drafts
grep -r "series.*Linux" content/            # Find series posts
find content/essays/ -name "*.md" | wc -l   # Count essays
```

### Building
```bash
hugo                           # Build site
rm -rf public/ && hugo        # Clean build
hugo --minify                 # Production build
```

---

## 📚 Further Reading

- [Hugo Documentation](https://gohugo.io/documentation/)
- [PaperMod Theme](https://github.com/adityatelange/hugo-PaperMod/wiki)
- [Hugo Content Organization](https://gohugo.io/content-management/organization/)
- [Hugo Frontmatter](https://gohugo.io/content-management/front-matter/)

---

## 🤔 Common Questions

**Q: Why don't I need a `type:` field in frontmatter?**  
A: Hugo determines the content type from the directory location. `content/essays/` → essays section.

**Q: Can a guide be in an essay series?**  
A: Yes! Series membership is independent of directory location. A guide in `content/guides/` can belong to "The Modernity Cycle" series.

**Q: What happens to my old posts in `content/posts/`?**  
A: They still work, but should be migrated to `content/essays/`, `content/guides/`, etc. for better organization.

**Q: How do I change a post's URL?**  
A: Move it to a different directory or add `url: /custom/path/` to frontmatter.

**Q: Can I have subdirectories?**  
A: Yes! `content/guides/linux/hyprland.md` → `/guides/linux/hyprland/`

---

*Last updated: October 2025*  
*This guide reflects the actual structure of your Hugo site.*
