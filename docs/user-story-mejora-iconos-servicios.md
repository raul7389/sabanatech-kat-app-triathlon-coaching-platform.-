# User Story: Mejora Visual de la Sección de Servicios

## Información General

| Campo         | Detalle                                              |
|---------------|------------------------------------------------------|
| **ID**        | US-001                                               |
| **Épica**     | Identidad Visual y Branding                          |
| **Rama**      | `feat/mejorar-iconos-services`                       |
| **Fecha**     | 2026-04-20                                           |
| **Estado**    | Completado                                           |

---

## Historia de Usuario

> **Como** visitante del sitio web de Kat3athlete,  
> **quiero** ver iconos representativos, precisos y visualmente consistentes en la sección de servicios,  
> **para** identificar fácilmente cada modalidad de entrenamiento y percibir una imagen profesional y alineada con la marca Ironman.

---

## Criterios de Aceptación

| # | Criterio | Estado |
|---|----------|--------|
| 1 | El icono de **Sprint & Olympic Triathlon** muestra las tres disciplinas (natación, ciclismo, carrera) en rojo | ✅ |
| 2 | El icono de **Ironman 70.3** es el logo M-dot oficial con el número 70.3 en blanco | ✅ |
| 3 | El icono de **Running** representa una figura corredora vectorial | ✅ |
| 4 | El icono de **Ironman 140.6 Full** muestra el lettering oficial IRONMAN | ✅ |
| 5 | Todos los iconos usan exactamente el mismo rojo `#E4002B` que los precios | ✅ |
| 6 | Los cuatro precios (`$70/month`, `$100/month`) quedan alineados al mismo nivel vertical | ✅ |
| 7 | Los iconos están centrados en la parte superior de cada tarjeta | ✅ |
| 8 | Los estilos globales están organizados en un archivo CSS separado | ✅ |

---

## Descripción Técnica

### 1. Icono Sprint & Olympic Triathlon
- **Archivo:** `/public/assets/triatlon_1.png`
- **Técnica:** CSS mask con `background-color: var(--iron-red)`
- **Escala:** `transform: scale(4.0)`
- **Resultado:** Icono vectorizado en rojo oficial usando la variable CSS del sistema de diseño

### 2. Icono Ironman 70.3
- **Archivo:** `/public/assets/ironman-70-3.svg`  
- **Origen:** SVG vectorial trazado del logo M-dot oficial (círculo + cuerpo rectangular con corte en M + texto "70.3")
- **Técnica:** CSS mask con `background-color: var(--iron-red)`
- **Escala:** `transform: scale(1.55)`
- **Color:** `#E4002B` (rojo oficial Ironman)

### 3. Icono Running
- **Archivo:** `/public/assets/running.svg`
- **Origen:** SVG vectorial de figura corredora
- **Técnica:** CSS mask con `background-color: var(--iron-red)`
- **Escala:** `transform: scale(5.0)`

### 4. Icono Ironman 140.6 Full
- **Archivo:** `/public/assets/ironman-140-6.svg`
- **Origen:** SVG vectorial del lettering IRONMAN oficial
- **Técnica:** CSS mask con `background-color: var(--iron-red)`
- **Escala:** `transform: scale(5.8)`

---

## Cambios de Layout y CSS

### Alineación de precios
```css
/* Antes */
.service-price {
    margin-top: 20px;
}

/* Después */
.service-price {
    margin-top: auto;
    padding-top: 20px;
}
```
> `margin-top: auto` en un flex container empuja el precio al fondo de cada tarjeta, garantizando alineación horizontal entre las cuatro tarjetas independientemente del contenido.

### Unificación de color
Todos los iconos usan CSS mask con la variable `--iron-red: #E4002B`, el mismo valor que usa `.service-price`. Esto garantiza coherencia visual exacta entre iconos y precios.

### Refactoring de estilos
- **Antes:** ~630 líneas de CSS inline dentro de `<style is:global>` en `BaseLayout.astro`
- **Después:** CSS extraído a `src/styles/global.css` e importado en el frontmatter de Astro
```js
// src/layouts/BaseLayout.astro
import '../styles/global.css';
```

---

## Archivos Modificados

| Archivo | Tipo de cambio |
|---------|---------------|
| `src/pages/index.astro` | Modificado — iconos de los 4 servicios |
| `src/layouts/BaseLayout.astro` | Modificado — CSS extraído, import agregado |
| `src/styles/global.css` | Creado — estilos globales del sitio |
| `public/assets/ironman-70-3.svg` | Creado — logo M-dot 70.3 vectorial rojo |
| `public/assets/ironman-140-6.svg` | Creado — lettering IRONMAN 140.6 vectorial rojo |
| `public/assets/running.svg` | Creado — icono corredor vectorial rojo |

---

## Notas de Diseño

- Se utilizó **CSS mask** en lugar de `<img>` para garantizar que todos los iconos hereden exactamente el mismo color que el resto de la UI mediante la variable `--iron-red`.
- El logo **M-dot Ironman 70.3** fue iterado múltiples veces hasta lograr la geometría exacta: círculo superior + cuerpo rectangular + corte triangular en la base formando la "M" característica.
- Los tamaños de escala fueron ajustados individualmente por icono según proporciones visuales del SVG fuente.
