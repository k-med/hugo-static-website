# KDOS - Hugo Site Management Guide

A practical guide to managing your Hugo-powered blog with PaperMod theme.

---

## 📁 Site Structure

```
content/
├── essays/         # Long-form philosophical writing
├── guides/         # Technical how-tos and tutorials
├── notes/          # Short reflections and observations
├── projects/       # Project case studies
├── series/         # Series landing pages (9 thematic collections)
│   ├── modernity-cycle/
│   ├── linux-frontier/
│   ├── artisans-return/
│   ├── nomads-almanac/
│   ├── techne-papers/
│   ├── european_correspondence/
│   ├── civic-virtue-project/
│   ├── metaphysics-everyday/
│   └── letters-from-the-collapse/
├── about/          # About page
├── archives/       # Auto-generated chronological archive
└── search/         # Auto-generated search page
```

---

## 🆕 Creating New Content

### Essays
```bash
hugo new --kind essay essays/my-new-essay.md
```

### Guides
```bash
hugo new --kind guide guides/my-new-guide.md
```

### Notes
```bash
hugo new --kind note notes/my-quick-thought.md
```

### Projects
```bash
hugo new --kind project projects/my-build-log.md
```

### Plain Content (No Template)
```bash
hugo new essays/freestyle-post.md
```

**All new content starts as `draft: true`**. Preview drafts with:
```bash
hugo server -D
```

---

## 📝 Understanding Frontmatter

Every content file has YAML frontmatter at the top. Here's what each field does:

```yaml
---
title: "Your Post Title"
date: 2025-10-22
draft: false              # Set to false to publish
type: "essay"             # Options: essay, guide, note, project
series: ["The Modernity Cycle"]  # Add to a series (optional)
categories: ["Philosophy", "Linux"]  # Broad groupings
tags: ["Stoicism", "Arch", "Privacy"]  # Specific topics
summary: "Brief description shown in lists"
showToc: true            # Show table of contents
tocopen: false           # Start with TOC collapsed
---
```

---

## 🔄 Moving Content Between Sections

### Example: Move an Essay to Guides

1. **Move the file:**
   ```bash
   mv content/essays/hyprland-setup.md content/guides/
   ```

2. **Update the frontmatter:**
   ```yaml
   # Change this:
   type: "essay"
   
   # To this:
   type: "guide"
   ```

3. **Rebuild the site:**
   ```bash
   rm -rf public/ && hugo
   ```

### Example: Move a Note to Essays

1. **Move the file:**
   ```bash
   mv content/notes/short-thought.md content/essays/
   ```

2. **Update frontmatter:**
   ```yaml
   type: "essay"  # Change from "note"
   # Add series if appropriate:
   series: ["Letters from the Collapse"]
   # Expand the summary for essay context
   summary: "A longer description..."
   ```

---

## 📚 Managing Series

### Adding Content to a Series

In your post's frontmatter:
```yaml
series: ["The Linux Frontier"]  # Single series
# OR
series: ["The Linux Frontier", "The Technē Papers"]  # Multiple series
```

### Removing from a Series

Simply delete or comment out the series line:
```yaml
# series: ["The Linux Frontier"]  # Commented out
```

Or use an empty array:
```yaml
series: []
```

### Creating a New Series

1. **Create the series directory:**
   ```bash
   mkdir -p content/series/my-new-series
   ```

2. **Create the series index:**
   ```bash
   nano content/series/my-new-series/_index.md
   ```

3. **Add this template:**
   ```yaml
   ---
   title: "My New Series"
   subtitle: "A tagline for your series"
   description: "What this series covers"
   date: 2025-10-22
   draft: false
   weight: 10  # Controls ordering in series list
   layout: "list"
   summary: "Brief description"
   showToc: false
   ---
   ## My New Series

   Introduction and overview of what readers will find here.
   ```

4. **Create an archetype (optional):**
   ```bash
   nano archetypes/my-new-series.md
   ```

   ```yaml
   ---
   title: "{{ replace .Name "-" " " | title }}"
   date: {{ .Date }}
   draft: true
   type: "essay"  # or guide, note, etc.
   series: ["My New Series"]
   tags: []
   summary: ""
   ---
   ```

### Deleting a Series

1. **Remove the series directory:**
   ```bash
   rm -rf content/series/my-old-series/
   ```

2. **Update all posts using that series:**
   ```bash
   # Find posts using the series
   grep -r "My Old Series" content/
   
   # Edit each file to remove the series reference
   ```

3. **Delete the archetype (if exists):**
   ```bash
   rm archetypes/my-old-series.md
   ```

---

## 🏷️ Managing Categories and Tags

### Modifying Categories/Tags

Edit the frontmatter in any post:

```yaml
# Before:
categories: ["Philosophy"]
tags: ["Stoicism", "Ethics"]

# After:
categories: ["Philosophy", "Politics"]  # Added Politics
tags: ["Stoicism"]  # Removed Ethics
```

### Finding All Uses of a Category/Tag

```bash
# Find all posts with a specific category
grep -r "categories.*Linux" content/

# Find all posts with a specific tag
grep -r "tags.*Hyprland" content/
```

### Renaming a Category/Tag Globally

```bash
# Example: Rename "Privacy" to "Digital Privacy"
find content/ -name "*.md" -type f -exec sed -i 's/"Privacy"/"Digital Privacy"/g' {} +

# Always verify changes:
git diff
```

### Unused Categories/Tags

Hugo automatically generates pages for all used categories and tags. When you remove them from all posts, their pages disappear automatically on next build.

---

## 🗑️ Deleting Content

### Delete a Single Post

```bash
# Delete the file
rm content/essays/old-post.md

# Rebuild
rm -rf public/ && hugo
```

### Delete All Drafts in a Section

```bash
# Preview what would be deleted
grep -l "draft: true" content/essays/*.md

# Delete them
grep -l "draft: true" content/essays/*.md | xargs rm
```

### Archive Instead of Delete

Create an archive directory:
```bash
mkdir -p content/archive
mv content/essays/old-post.md content/archive/
```

Add to the post's frontmatter:
```yaml
draft: true  # Won't appear on site
```

---

## 🔍 Common Tasks

### Publishing a Draft

Change in frontmatter:
```yaml
draft: false
```

### Unpublishing (Making a Draft Again)

```yaml
draft: true
```

### Bulk Change Draft Status

```bash
# Publish all drafts in essays/
find content/essays/ -name "*.md" -type f -exec sed -i 's/draft: true/draft: false/g' {} +

# Make all essays drafts (to unpublish)
find content/essays/ -name "*.md" -type f -exec sed -i 's/draft: false/draft: true/g' {} +
```

### Change Date Format

Hugo uses ISO 8601. Valid formats:
```yaml
date: 2025-10-22
date: 2025-10-22T14:30:00+11:00
```

### Update Multiple Posts at Once

Using `sed` for batch edits:
```bash
# Add a tag to all Linux guides
find content/guides/ -name "*.md" -type f -exec sed -i '/tags:/s/\]/", "Advanced"\]/' {} +

# Add series to all essays
find content/essays/ -name "*.md" -type f -exec sed -i '4a series: ["The Modernity Cycle"]' {} +
```

---

## 🚀 Development Workflow

### Start Dev Server
```bash
./dev.sh
# OR
hugo server -D --bind 0.0.0.0 --disableFastRender
```

**Access at:** `http://localhost:1313`

### Clean Build
```bash
rm -rf public/ resources/ && hugo
```

### Build for Production
```bash
hugo --minify
```

### Check for Errors
```bash
hugo --verbose
```

---

## 🔧 Site Configuration

### Modify Site Title/Description

Edit `hugo.toml`:
```toml
title = 'KDOS'
[params]
  description = "Your new description"
```

### Add/Remove Menu Items

Edit `hugo.toml`:
```toml
[menu]
  [[menu.main]]
    name = "Essays"
    url = "/essays/"
    weight = 1  # Lower number = appears first
```

### Change Theme Settings

In `hugo.toml` under `[params]`:
```toml
ShowReadingTime = true
ShowWordCount = false
defaultTheme = "dark"  # Options: light, dark, auto
```

---

## 📊 Content Organization Best Practices

### Type → Directory Mapping
- **Essays** → `content/essays/` (type: "essay")
- **Guides** → `content/guides/` (type: "guide")  
- **Notes** → `content/notes/` (type: "note")
- **Projects** → `content/projects/` (type: "project")

### Series Usage
Use series for multi-part narratives or thematic collections that span different content types.

### Categories vs Tags
- **Categories**: Broad (3-5 max per post) — Philosophy, Linux, Craft
- **Tags**: Specific (5-10 max per post) — Stoicism, Arch, Hyprland, Privacy

### File Naming
- Use lowercase with hyphens: `my-post-title.md`
- Avoid special characters: `~/!@#$%`
- Date prefixes optional: `2025-10-22-my-post.md`

---

## 🛠️ Troubleshooting

### Post Not Showing Up
1. Check `draft: true` in frontmatter
2. Verify date isn't in the future
3. Rebuild: `rm -rf public/ && hugo`

### Series Not Linking
1. Ensure series name matches exactly (case-sensitive)
2. Check `content/series/[series-name]/_index.md` exists
3. Rebuild site

### Changes Not Appearing
1. Stop and restart dev server
2. Clear browser cache
3. Use `--disableFastRender` flag

### Broken Internal Links
Use relative paths:
```markdown
[Link to about](/about/)
[Link to essay](/essays/my-essay/)
```

---

## 📦 Deployment

Site auto-deploys to Cloudflare Pages on push to `main` branch.

**Manual deploy:**
```bash
hugo --minify
# Upload public/ directory to your host
```

---

## 🔗 Quick Reference

| Command | Purpose |
|---------|---------|
| `hugo new --kind essay essays/new.md` | Create essay |
| `hugo new --kind guide guides/new.md` | Create guide |
| `hugo server -D` | Preview with drafts |
| `hugo` | Build site |
| `rm -rf public/ && hugo` | Clean build |
| `grep -r "pattern" content/` | Search content |
| `find content/ -name "*.md" \| wc -l` | Count posts |

---

## 📚 Further Reading

- [Hugo Documentation](https://gohugo.io/documentation/)
- [PaperMod Theme Docs](https://github.com/adityatelange/hugo-PaperMod/wiki)
- [Hugo Frontmatter Variables](https://gohugo.io/content-management/front-matter/)

---

*Last updated: October 2025*
