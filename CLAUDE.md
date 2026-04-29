# CLAUDE.md

## Project Overview

Landing page for Kat3athlete (Katherine Gomez Aya), an IRONMAN-certified triathlon coach. Built with Astro v6 (static SSG), pure CSS, and client-side JS for i18n and SPA navigation.

## Commands

```bash
npm run dev       # Start dev server
npm run build     # Production build to dist/
npm run preview   # Preview production build
```

## Architecture Decisions

- **SPA navigation**: Sections toggle visibility via JS `showSection()` instead of separate pages. This is intentional — the i18n system depends on a single-page structure where all translations live in one `T` object in `index.astro`.
- **No framework JS**: All interactivity is vanilla JS in a `<script is:inline>` block. No React/Vue/Svelte. The site is 100% static HTML + CSS with sprinkles of JS for navigation, i18n, forms, lightbox, and carousel.
- **External images**: Gallery and service icons are hosted on Cloudflare R2 CDN. They cannot use Astro's `<Image />` component (which only works with local imports). Only the logo uses `<Image />`.
- **CSS organization**: Split into 9 domain files under `src/styles/`, imported in order by `BaseLayout.astro`. No preprocessor, no CSS modules — just global stylesheets with CSS Custom Properties for theming.
- **i18n**: Client-side only. The `T` object in `index.astro` holds all translations (EN, ES, IT, PT). `setLang()` walks DOM elements with `data-i18n` attributes.

## Key Files

- `src/pages/index.astro` — Page orchestrator + all JS (i18n, navigation, forms, lightbox, validation)
- `src/layouts/BaseLayout.astro` — `<head>`, fonts, meta, CSS imports
- `src/styles/variables.css` — All CSS Custom Properties (design tokens)
- `src/components/` — One component per section (Hero, About, Services, Testimonials, Contact, etc.)

## Gotchas

- The `<form>` in Contact.astro uses Web3Forms API (access key hardcoded). It also has `data-netlify="true"` as a secondary fallback.
- CSS specificity: `layout.css` contains shared UI (buttons, modal, lightbox, footer). Section-specific CSS lives in its own file.
- The `index.astro` script block is ~450 lines because it contains the full i18n translation table for 4 languages. This is expected — do not try to split it into external files (Astro `is:inline` scripts don't support module imports).

## Style Guide

- Brand primary: `--iron-red: #E4002B`
- Background: `--iron-black: #080808` (not pure black)
- Display font: Oswald (headings, buttons, badges)
- Body font: Roboto (paragraphs, form labels)
- Breakpoints: 968px (tablet), 768px (mobile), 480px (small mobile)
