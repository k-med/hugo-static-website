# KDOS - Hugo Static Site

Field notes on craft, code, and the examined life. Built with Hugo and PaperMod.

## 📁 Content Structure

```
content/
├── posts/          # All blog posts (essays, guides, notes)
│   ├── linux/      # Technical guides
│   ├── essays/     # Long-form writing
│   └── meta/       # Site updates
├── projects/       # Case studies & real-world builds
├── series/         # 9 thematic series landing pages
├── about/          # About page
├── archives/       # Chronological archive
└── search/         # Search page
```

## 🎯 The 9 Series

1. **The Modernity Cycle** - Essays on civilization, decay, and renewal
2. **The Linux Frontier** - FOSS, privacy, and digital sovereignty
3. **The Artisan's Return** - Craft, trades, and local skill
4. **Nomad's Almanac** - Working abroad, WHVs, seasonal gigs
5. **The Technē Papers** - Engineering, data, elegant systems
6. **The European Correspondence** - Letters from cities and archives
7. **The Civic Virtue Project** - Mutual aid, institutions, rituals
8. **Metaphysics of the Everyday** - Stoic habits, attention, practice
9. **Letters from the Collapse** - Clear-eyed observations with practical antidotes

## ✍️ Creating Content

### New post (general)
```bash
hugo new posts/my-post-title.md
```

### New post from series template
```bash
hugo new --kind modernity-cycle posts/essays/new-essay.md
hugo new --kind linux-frontier posts/linux/new-guide.md
hugo new --kind civic-virtue-project posts/civic-virtue-blueprint.md
```

### New project
```bash
hugo new --kind project projects/fence-rebuild.md
```

## 🚀 Development

```bash
# Start dev server (includes drafts)
./dev.sh
# or
hugo server -D --bind 0.0.0.0

# Build for production
hugo

# Clean build
rm -rf public/ && hugo
```

## 🔧 Available Archetypes

- `default.md` - Basic post
- `project.md` - Project case study
- **Series templates:**
  - `modernity-cycle.md`
  - `linux-frontier.md`
  - `artisans-return.md`
  - `civic-virtue-project.md`
  - `nomads-almanac.md`
  - `techne-papers.md`
  - `european-correspondence.md`
  - `metaphysics-everyday.md`
  - `letters-from-the-collapse.md`

## 📦 Dependencies

- Hugo Extended (v0.151.2+)
- PaperMod theme (git submodule)

## 🌐 Deployment

Site deploys automatically to Cloudflare Pages on push to main branch.

Local preview: `http://localhost:1313`  
Production: `https://kdos.xyz`

---

*Built with purpose. Maintained with care.*
