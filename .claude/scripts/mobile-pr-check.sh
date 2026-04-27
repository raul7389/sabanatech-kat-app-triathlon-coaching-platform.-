#!/bin/bash
# Auto PR + Mobile Validation Hook
# Se ejecuta automáticamente cuando Claude termina de hacer cambios

set -e

# Agregar PATH de gh CLI en Windows
export PATH="$PATH:/c/Program Files/GitHub CLI"

BRANCH=$(git branch --show-current 2>/dev/null)
ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

# --- 1. No ejecutar en rama main ---
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
  echo '{"suppressOutput": true}'
  exit 0
fi

# --- 2. Verificar si hay commits sin pushear ---
UNPUSHED=$(git log "origin/$BRANCH..HEAD" --oneline 2>/dev/null | wc -l | tr -d ' ')

if [ "$UNPUSHED" -eq 0 ]; then
  echo '{"suppressOutput": true}'
  exit 0
fi

echo ">>> $UNPUSHED commit(s) pendiente(s) detectado(s) en rama '$BRANCH'"

# --- 3. Validación Mobile / Responsive ---
WARNINGS=()

# Archivos HTML modificados
HTML_FILES=$(git diff --name-only "origin/$BRANCH..HEAD" 2>/dev/null | grep -E '\.(html|astro)$' || true)
CSS_FILES=$(git diff --name-only "origin/$BRANCH..HEAD" 2>/dev/null | grep -E '\.(css|scss|sass)$' || true)

# 3a. Verificar viewport meta tag en HTML
for f in $HTML_FILES; do
  FILEPATH="$ROOT/$f"
  if [ -f "$FILEPATH" ]; then
    if ! grep -qi 'meta.*viewport' "$FILEPATH"; then
      WARNINGS+=("FALTA viewport meta tag en: $f")
    fi
  fi
done

# 3b. Verificar media queries en CSS
for f in $CSS_FILES; do
  FILEPATH="$ROOT/$f"
  if [ -f "$FILEPATH" ]; then
    if ! grep -q '@media' "$FILEPATH"; then
      WARNINGS+=("SIN media queries en: $f — revisar responsividad")
    fi
    # Detectar anchos fijos grandes (>768px) que pueden romper mobile
    FIXED=$(grep -oP 'width:\s*\K[0-9]+(?=px)' "$FILEPATH" 2>/dev/null | awk '$1>768' || true)
    if [ -n "$FIXED" ]; then
      WARNINGS+=("Ancho fijo >768px detectado en $f — usar max-width o unidades relativas")
    fi
  fi
done

# Mostrar warnings si los hay
if [ ${#WARNINGS[@]} -gt 0 ]; then
  echo ""
  echo "=== ADVERTENCIAS MOBILE ==="
  for w in "${WARNINGS[@]}"; do
    echo "  ⚠  $w"
  done
  echo "==========================="
fi

# --- 4. Verificar que gh CLI esté disponible ---
if ! command -v gh &>/dev/null; then
  MSG="gh CLI no instalado. Instálalo en: https://cli.github.com — luego ejecuta: gh auth login"
  echo ""
  echo "ERROR: $MSG"
  echo "{\"systemMessage\": \"PR no creado — $MSG\"}"
  exit 0
fi

# --- 5. Push de la rama ---
echo ""
echo ">>> Pusheando rama '$BRANCH'..."
git push -u origin "$BRANCH" 2>&1

# --- 6. Verificar si ya existe un PR para esta rama ---
EXISTING_PR=$(gh pr list --head "$BRANCH" --json number --jq '.[0].number' 2>/dev/null || echo "")

if [ -n "$EXISTING_PR" ]; then
  PR_URL=$(gh pr view "$EXISTING_PR" --json url --jq '.url' 2>/dev/null || echo "")
  echo ">>> PR ya existe: $PR_URL"
  echo "{\"systemMessage\": \"PR actualizado automáticamente: $PR_URL\"}"
  exit 0
fi

# --- 7. Crear PR ---
MOBILE_NOTE=""
if [ ${#WARNINGS[@]} -gt 0 ]; then
  MOBILE_NOTE=$'\n\n### ⚠ Advertencias Mobile\n'
  for w in "${WARNINGS[@]}"; do MOBILE_NOTE+="- $w"$'\n'; done
fi

echo ""
echo ">>> Creando Pull Request..."
PR_URL=$(gh pr create \
  --base main \
  --head "$BRANCH" \
  --title "$(git log -1 --pretty=%s)" \
  --body "$(cat <<EOF
## Cambios
$(git log origin/main.."$BRANCH" --pretty="- %s" 2>/dev/null)

## Checklist Mobile
- [ ] Viewport meta tag presente
- [ ] Media queries implementadas
- [ ] Texto legible sin zoom (mín. 16px)
- [ ] Botones con área táctil ≥ 44px
- [ ] Imágenes responsivas (max-width: 100%)
- [ ] Sin scroll horizontal no deseado
$MOBILE_NOTE
EOF
)" 2>&1)

echo ">>> PR creado: $PR_URL"
echo "{\"systemMessage\": \"Pull Request creado: $PR_URL\"}"
