+++
date = '2025-10-23T15:06:53+11:00'
draft = false
title = 'Build Your Own Kdos'
+++

# Build Your Own KDOS (10-Minute Clone, Hugo + Cloudflare Pages)

Do you have a spare 10 minutes to build your own free static website with state-of-the-art security that runs on some of the fastest global edge servers, free of charge?

I hold no punches with KDOS — the whole site’s source is public. Copy it and ship your own:

**Repo:** [https://github.com/k-med/hugo-static-website](https://github.com/k-med/hugo-static-website)

Follow along to get yours up and running now.

## What I use

- A text editor (I use VSCodium; vim works great too)
    
- GitHub account
    
- Cloudflare account
    
- Linux (or Windows + WSL; macOS works the same)
    
- (Optional) A purchased domain (e.g., `mysite.com`)
    

---

## 1) Fork → Connect → Deploy (fast path)

**Fork the repo**

1. Open the repo and click **Fork** to your GitHub account.
    

**Connect to Cloudflare Pages**

1. Cloudflare Dashboard → **Pages** → **Create a project** → **Connect to Git**.
    
2. Pick your fork.
    

**Build settings I use**

- Framework preset: **None** (Hugo works fine without the preset)
    
- Build command:
    
    `hugo --gc --minify`
    
- Output directory: `public`
    
- Environment variables (pin the exact Hugo version you have locally):
    
    `HUGO_VERSION = 0.128.0   # example — set yours`
    
    If the repo uses Hugo Modules: `HUGO_ENABLEMODULES = true`  
    If the repo uses submodules: enable **Git submodules** in Pages settings.
    

**Deploy**

- Cloudflare builds and serves `https://<project>.pages.dev`.
    
- Every push to your default branch triggers a new deployment.
    

> Time check: that’s the 10-minute version done.

---

## 2) Local edits (optional but recommended)

Clone your fork:

`git clone git@github.com:<you>/hugo-static-website.git cd hugo-static-website`

Dev server:

`hugo server -D # http://localhost:1313`

Commit + push:

`git add . git commit -m "content: first post; style: header polish" git push`

Cloudflare auto-deploys.

---

## 3) Make it yours

Open `hugo.toml` and set the basics:

`baseURL = "https://<project>.pages.dev/"   # change after adding a custom domain languageCode = "en-us" title = "KDOS"                             # rename your site here paginate = 10 enableEmoji = true`

Create a post:

`hugo new blog/hello-world.md`

Open the file and set `draft: false` when ready to publish.

Images live under `static/images/...` and are referenced as `/images/<name>.png`.

---

## 4) Custom domain (optional)

Pages → your project → **Custom domains** → Add domain.  
If DNS is on Cloudflare, it’s one click and SSL is automatic.  
Update `baseURL` to `https://yourdomain.tld/`.

---

## 5) Quality, speed & security defaults

- Cloudflare edge (HTTP/2/3, free SSL, global CDN, atomic deploys, rollbacks)
    
- Pin `HUGO_VERSION` to match local = reproducible builds
    
- Root-relative assets (`/images/...`) = fewer broken links when changing domains
    
- `sitemap = true` and sensible metadata in `hugo.toml` for SEO
    
- No server to hack, no database to patch — just static files on the edge
    

---

## 6) Troubles I actually see (and fixes)

- **Prod doesn’t match local:** Hugo version mismatch → set `HUGO_VERSION` in Pages.
    
- **Theme missing:** If using submodules, enable submodule cloning (or switch to Hugo Modules).
    
- **Drafts not live:** Remove `draft: true`.
    
- **404s on nested routes:** Ensure Hugo outputs the expected `index.html` per section; avoid SPA assumptions.
    

---

## 7) Minimal ignore & parity build

`.gitignore`:

`/public/ /resources/ .hugo_build.lock`

Release-parity local build:

`hugo --gc --minify # artifacts → public/`

---

## 8) Suggested structure (KDOS style)

- `content/about/_index.md` — the site’s “why”
    
- `content/projects/` — real builds, costs, lessons
    
- `content/blog/` — essays/notes (Modernity, Linux privacy, Stoic practice, etc.)
    
- `content/archives/`, `content/search/` — helpers
    

Add `_index.md` to sections to control listings/series pages via front matter.

---

## 9) Branching & previews

`git checkout -b feature/new-section # edit... git commit -m "feat: new section; content: essay" git push -u origin feature/new-section`

Open a PR on GitHub — Cloudflare Pages creates a **preview deployment** for review.

---

## 10) License & copying

The repo is public specifically so others can copy and reuse this setup. Fork it, ship it, and make it yours. If you keep my structure, a link back is appreciated but not required.