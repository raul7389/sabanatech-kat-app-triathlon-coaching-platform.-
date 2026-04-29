# Kat3athlete — Triathlon Coaching Platform

Landing page profesional para **Katherine Gomez Aya**, coach certificada IRONMAN con +6 anos de experiencia. El sitio funciona como herramienta de captacion de atletas ofreciendo informacion sobre sus servicios de entrenamiento, testimonios de clientes y formulario de contacto.

## Tech Stack

| Capa | Tecnologia |
|------|-----------|
| Framework | [Astro](https://astro.build/) v6 (SSG, output `static`) |
| CSS | CSS puro con Custom Properties, sin preprocesadores |
| Fonts | Google Fonts (Oswald + Roboto), carga async con preload |
| Images | CDN externo Cloudflare R2, formato `.webp` con fallback `<picture>` |
| Forms | [Web3Forms](https://web3forms.com/) para envio de contacto y testimonios |
| Deploy | GitHub Pages (static build) |
| i18n | Sistema propio client-side con objeto `T` (EN, ES, IT, PT) |

## Estructura del Proyecto

```
src/
├── components/
│   ├── Hero.astro              # Banner principal con CTA
│   ├── About.astro             # Biografia + Proven Results + Galeria Journey
│   ├── Services.astro          # Cards de planes de entrenamiento
│   ├── Testimonials.astro      # Carousel horizontal de testimonios
│   ├── Contact.astro           # Formulario + info de contacto
│   ├── Lightbox.astro          # Visor fullscreen de fotos
│   ├── Navbar.astro            # Header fijo + nav + language switcher
│   ├── Footer.astro            # Footer con link a Instagram
│   └── TestimonialModal.astro  # Modal para agregar nuevos testimonios
├── layouts/
│   └── BaseLayout.astro        # <head>, meta, fonts, CSS imports
├── pages/
│   └── index.astro             # Orquestador de componentes + script i18n/JS
├── styles/
│   ├── variables.css           # Custom Properties (colores, tipografia, spacing)
│   ├── base.css                # Reset + body
│   ├── layout.css              # Header, nav, botones, footer, modal, lightbox
│   ├── hero.css                # Seccion Hero
│   ├── about.css               # About + Proven Results + Gallery
│   ├── services.css            # Cards de servicios
│   ├── testimonials.css        # Cards de testimonios + carousel
│   ├── contact.css             # Formulario + validacion visual
│   └── responsive.css          # Media queries (tablet, mobile, small mobile)
└── assets/
    └── kat3logo.webp           # Logo optimizado con <Image /> de Astro
```

## Inicio Rapido

```bash
# Instalar dependencias
npm install

# Servidor de desarrollo
npm run dev

# Build para produccion
npm run build

# Preview del build
npm run preview
```

## Arquitectura

### Navegacion SPA

El sitio opera como una Single Page Application. Las secciones (`#home`, `#about`, `#services`, `#testimonials`, `#contact`) se muestran/ocultan via JS con `showSection()`. Cada seccion tiene `display: none` por defecto y `.section.active` la muestra con transicion fade-in.

### Sistema i18n

El archivo `index.astro` contiene un objeto `T` con traducciones para 4 idiomas (EN, ES, IT, PT). La funcion `setLang()` recorre los elementos con `data-i18n` y `data-i18n-ph` para actualizar texto y placeholders en tiempo real.

### Imagenes

- **Logo**: Importado localmente y procesado por Astro `<Image />` (optimizacion automatica)
- **Galeria + iconos de servicios**: Servidos desde CDN Cloudflare R2 (`pub-0789916971714c4181501344ff932029.r2.dev`). Usan `<picture>` con `<source type="image/webp">` y fallback JPG/PNG

### Formularios

Ambos formularios (contacto y testimonios) envian datos via `fetch` a la API de Web3Forms. El formulario de contacto tambien tiene `data-netlify="true"` como fallback.

### Validacion del Formulario

Los campos del formulario de contacto tienen validacion visual en tiempo real:
- Al perder foco (`blur`): se valida el campo
- Campos validos: borde verde (`#22c55e`)
- Campos invalidos: borde rojo (`#ef4444`)
- Las clases se limpian al hacer submit exitoso

## Design Tokens (CSS Custom Properties)

| Variable | Valor | Uso |
|----------|-------|-----|
| `--iron-red` | `#E4002B` | Color primario, CTAs, acentos |
| `--iron-black` | `#080808` | Fondo principal |
| `--iron-dark` | `#1A1A1A` | Fondos de tarjetas |
| `--iron-white` | `#FFFFFF` | Texto principal |
| `--iron-accent` | `#FF1A1A` | Hover states |
| `--font-display` | Oswald | Titulos, botones, badges |
| `--font-body` | Roboto | Parrafos, labels |

## Convenciones

- **CSS**: Un archivo por dominio/seccion. Sin BEM ni frameworks. Clases descriptivas en kebab-case
- **Componentes**: Cada seccion del sitio es un `.astro` independiente. Sin props por ahora (contenido hardcoded + i18n via JS)
- **JS**: Todo inline con `<script is:inline>` en `index.astro`. Funciones globales accesibles para los `onclick` del HTML
- **Responsive**: 3 breakpoints — tablet (968px), mobile (768px), small mobile (480px)

## Deploy

El proyecto se despliega automaticamente a GitHub Pages en cada push a `main`. El build genera archivos estaticos en `dist/`.

```bash
npm run build   # Genera dist/
```

## Contacto del Equipo

- **Desarrollador**: Brandon Gomez (SabanaTech)
- **Cliente/Coach**: Katherine Gomez Aya (@kat3athlete)
