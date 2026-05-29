---
name: ldd-presentation
description: Genera el archivo .pptx de la presentación del curso a partir del storyboard aprobado. Usa python-pptx para construir cada slide, imágenes del stock multimedia de Ingnovarte (SharePoint) e íconos de Iconify.
triggers:
  - generar pptx
  - crear presentación
  - generar presentacion
  - exportar a powerpoint
  - crear pptx
  - presentación final
  - montar presentación
  - montar la presentacion
  - armar el pptx
metadata:
  version: "1.3"
  author: "ingnovarte"
  updated_at: "2026-05-29"
license: "proprietary"
---

## Modo de ejecución

Esta skill ejecuta código Python, descarga imágenes de SharePoint y llama la API de Iconify. Para proteger el contexto del orquestador:

**Esta skill DEBE ejecutarse como sub-agente. No ejecutar inline.**

Prompt mínimo para el sub-agente:
> Ejecuta la skill `ldd-presentation` para el curso [código].
> Lee el SKILL.md completo antes de comenzar: `skills/ldd-presentation/SKILL.md`
> Lee el storyboard desde Engram: `ldd/{código}/storyboard`
> Lee el tema visual desde Engram: `ldd/{código}/tema-visual`
> Genera el .pptx y guárdalo en: `cursos/{carpeta}/03_Creación/presentacion-{código}.pptx`
> Guarda el path del archivo en Engram: `ldd/{código}/presentation-path`

---

## Prerequisitos de entorno

Esta skill accede a SharePoint vía el MCP `ms365-work`. Antes de ejecutarla:

1. Verifica que `ms365-work` esté configurado en tu MCP (Claude Code: `.mcp.json` / OpenCode: `opencode.json`).
   El installer lo configura automáticamente si Node.js 18+ está instalado.
2. Si es la primera vez, el servidor mostrará un código de dispositivo para autenticarte con tu cuenta org de Microsoft.
3. Ver instrucciones completas en `skills/_shared/ms365-setup.md`.

> Si `ms365-work` no está disponible, la skill continúa y genera el .pptx con placeholders de color.
> El reporte final lista qué slides quedaron sin imagen.

---

## Modo de trabajo

Antes de generar ningún slide, preguntar al usuario:

> "Esta presentación tiene **[N] tópicos** y **[M] slides** según el storyboard.
> ¿Cómo quieres que trabaje?
>
> **A) Por tópico** *(recomendado)* — genero las slides de un tópico, te reporto qué imágenes encontré y cuáles quedaron como placeholder, y espero tu aprobación antes de continuar.
> **B) Una pasada** — genero todas las slides de una vez y te entrego el .pptx completo con el reporte final.
> **C) Otro** — especifica (ej: 'solo portada y divisores primero', 'tópicos 1 al 3 juntos')."

**Default si no responde:** opción A (por tópico — permite resolver imágenes faltantes antes de continuar).

### Validación por unidad de trabajo

Al terminar cada tópico, presentar este reporte **antes de continuar con el siguiente**:

```
─── Validación — Tópico [N]: [Nombre] ────────────────────────────────
Slides generadas  : [N]
Imágenes BBOK     : [N] slides con imagen técnica del BBOK
Imágenes SharePoint: [N] slides con foto contextual
Placeholders      : [N] slides sin imagen — lista:
                    · Slide [X] — [título] (keywords buscadas: [...])
                    · Slide [Y] — [título] (keywords buscadas: [...])
Íconos Iconify    : [N]

¿Apruebas este tópico, o quieres ajustar imágenes antes de continuar?
(Puedes indicar rutas de imágenes específicas para los placeholders)
──────────────────────────────────────────────────────────────────────
```

**Criterios de bloqueo** — no continuar al siguiente tópico si:
- Más del 50% de las slides del tópico son placeholders
- El usuario quiere asignar imágenes manualmente a los placeholders antes de continuar
- El usuario detecta que una imagen BBOK no corresponde al contenido del slide

**En modo "Una pasada":** generar todo, guardar el .pptx parcial por tópico en temp, ensamblar al final. Presentar reporte global con lista completa de placeholders.

---

## When to Use

Usa esta skill cuando:
- El storyboard está completo y aprobado (generado por `ldd-storyboard`)
- El cliente aprobó el tema visual (`ldd/{código}/tema-visual` existe en Engram)
- Estás en la fase de Creación y necesitas entregar la presentación en formato editable .pptx

No uses esta skill para:
- Generar el storyboard (usa `ldd-storyboard`)
- Modificar el contenido del curso (usa `ldd-bok` o `ldd-storyboard`)

## Prerequisites

Verificar antes de ejecutar:

| Requisito | Cómo verificar | Si falta |
|---|---|---|
| Storyboard en Engram | `mem_search("ldd/{código}/storyboard")` | Detener — ejecutar `ldd-storyboard` primero |
| Tema visual en Engram | `mem_search("ldd/{código}/tema-visual")` | Usar paleta por defecto (ver ## Tema visual por defecto) |
| python-pptx instalado | `pip show python-pptx` | `pip install python-pptx` |
| Pillow instalado | `pip show Pillow` | `pip install Pillow` |
| requests instalado | `pip show requests` | `pip install requests` |
| cairosvg instalado | `pip show cairosvg` | `pip install cairosvg` (opcional — solo si se usan íconos) |

## Steps

### 1. Leer inputs

- Leer storyboard: `mem_search("ldd/{código}/storyboard")` → `mem_get_observation(id)`
- Leer tema visual: `mem_search("ldd/{código}/tema-visual")` → si no existe, usar paleta por defecto
- Leer manifiesto de imágenes BBOK: `mem_search("ldd/{código}/bbok-images")` → si existe, construir índice `{ id_bbok: ruta_imagen }` y `{ seccion_bbok: ruta_imagen }` para lookup rápido
- Determinar `{carpeta}` del curso desde el path del storyboard o preguntando al usuario

### 2. Parsear el storyboard

Extraer de cada sección `### Slide [N] — [TIPO] — [Título]`:

| Campo | Fuente en el storyboard |
|---|---|
| `num` | N en `### Slide [N]` |
| `tipo` | PORTADA / AGENDA / DIVISOR / CONCEPTO / TÉCNICO / EJEMPLO / ACTIVIDAD / CIERRE |
| `titulo` | texto después del tipo |
| `texto_pantalla` | tabla bajo `**TEXTO EN PANTALLA**` — extraer pares (Elemento, Texto) |
| `historia_visual` | texto bajo `**HISTORIA VISUAL**` |
| `recurso_visual` | valor de `- Recurso visual:` en BRIEF DISEÑO |
| `descripcion_visual` | valor de `- Descripción visual:` (40–60 palabras) |
| `punto_atencion` | valor de `- Punto de atención:` |
| `paleta_slide` | valor de `- Paleta:` |
| `imagen_bbok` | valor de `- Imagen BBOK:` en BRIEF DISEÑO (ruta relativa o `N/A`) |
| `huella_bbok` | texto bajo `**HUELLA BBOK**` (puede ser vacío) |
| `nota_facilitador` | texto bajo `**NOTA FACILITADOR**` |

Resultado: lista de dicts Python, uno por slide. Verificar que el número total de slides coincide con la arquitectura del storyboard.

### 3. Indexar multimedia SharePoint

Descargar el índice pre-generado `_index.md` desde SharePoint y parsearlo. Es una sola llamada a la API en lugar de listar carpeta por carpeta.

**Configuración:**
```
drive_id     = "b!_4s4r1EyNE-qv91Z8XTqUv51NwO5vgxIh4KXaqdQ2TkCI2ZatiG6R4eTl7SCbpzr"
folder_id    = "017L4IGJP54PUFCV2WOVAIZECMDSL22J3Y"
index_path   = "/drives/b!_4s4r1EyNE-qv91Z8XTqUv51NwO5vgxIh4KXaqdQ2TkCI2ZatiG6R4eTl7SCbpzr/items/017L4IGJP54PUFCV2WOVAIZECMDSL22J3Y:/_index.md:/content"
```

**Procedimiento:**
1. Llamar `mcp__ms365-work__download-bytes` con `path = index_path`
2. Decodificar el contenido (bytes → UTF-8)
3. Parsear la tabla markdown — ignorar líneas que empiecen con `#`, `<!--` o `|---`:
   ```python
   index = {}
   for line in content.splitlines():
       if not line.startswith('|') or line.startswith('|---'):
           continue
       cols = [c.strip() for c in line.strip('|').split('|')]
       if len(cols) >= 4 and cols[0] != 'path':
           rel_path, description, tags, category = cols[0], cols[1], cols[2], cols[3]
           index[rel_path] = {'description': description, 'tags': tags, 'category': category}
   ```
4. Guardar `index` en memoria (no en Engram — es temporal). Total esperado: ~3,252 entradas.

> Si la descarga falla (sin autenticación o error de red): continuar con `placeholder = True` para todas las imágenes y notificar al usuario al final.

### 4. Resolver imagen por slide

Para cada slide con `tipo` en {PORTADA, DIVISOR, CONCEPTO, TÉCNICO, EJEMPLO}:

**Orden de prioridad (aplicar en este orden — detenerse al primer match):**

**Prioridad 1 — Imagen BBOK** (el SME ya validó este visual):
1. Leer campo `imagen_bbok` del slide_data (extraído del storyboard)
2. Si tiene valor (no es `N/A` ni vacío): resolver ruta absoluta = `{carpeta_curso}/{imagen_bbok}`
3. Si el archivo existe en disco: `img_path = ruta_absoluta` → usar directamente, **sin descargar nada**
4. Si la ruta no existe en disco: intentar reconstruir desde el índice Engram `bbok-images`

**Prioridad 2 — SharePoint multimedia** (foto contextual cuando no hay imagen BBOK):
1. Extraer keywords del campo `descripcion_visual`: sustantivos técnicos y operativos (ignorar artículos, preposiciones, verbos comunes)
2. Para cada entrada en el índice: `score = número de keywords que aparecen en (description + " " + tags).lower()`
3. Elegir la entrada con mayor score (empate: primera en orden de aparición en el índice)
4. Si `score > 0`: descargar con `mcp__ms365-work__download-bytes` usando path `/drives/{drive_id}/root:/{rel_path}:/content` → guardar en `C:/Temp/ldd-pres-{código}/img_{num}.jpg`

**Prioridad 3 — Placeholder** (último recurso):
- Si `score == 0` o índice SharePoint vacío: `img_path = None` (rectángulo de color sólido del tema)
- Agregar al reporte final: `[PENDIENTE: imagen para slide {num} — {titulo}]`

### 5. Resolver íconos (opcional)

Aplicar solo cuando:
- `recurso_visual == "dato-prominente"` Y la descripción menciona un indicador numérico o estado
- `tipo == "CIERRE"` y se quieren íconos de síntesis
- La descripción visual menciona explícitamente "ícono" o "símbolo"

**Iconify API:**
```
# Buscar ícono
GET https://api.iconify.design/search?query={término}&limit=5
# Respuesta: { "icons": ["mdi:bolt", "ph:wrench-bold", ...] }

# Descargar SVG con color blanco, tamaño 128px
GET https://api.iconify.design/{prefix}/{name}.svg?color=%23FFFFFF&width=128&height=128

# Convertir a PNG (requiere cairosvg)
import cairosvg
cairosvg.svg2png(url=svg_url, write_to=png_path, output_width=128, output_height=128)
```

Guardar PNG en `C:/Temp/ldd-pres-{código}/icon_{num}.png`

### 6. Leer tema visual

Si `ldd/{código}/tema-visual` existe en Engram, extraer:
- `paleta_primaria`: color de fondo (HEX)
- `paleta_acento`: color de acento (HEX)
- `paleta_texto`: color de texto sobre fondo oscuro (usualmente #FFFFFF o #F5F5F5)
- `fuente_titulo`: nombre de la fuente para títulos
- `fuente_cuerpo`: nombre de la fuente para cuerpo

Si no existe, usar la paleta por defecto (ver sección ## Tema visual por defecto).

### 7. Generar y ejecutar el script Python

Escribir el script completo a `C:/Temp/ldd-pres-{código}/build.py` y ejecutar con `python C:/Temp/ldd-pres-{código}/build.py`.

**Estructura del script:**
```python
from pptx import Presentation
from pptx.util import Inches, Pt, Emu
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN
from pptx.oxml.ns import qn
from lxml import etree
import os

# --- Configuración ---
OUTPUT_PATH = r"{output_path}"
IMG_DIR = r"C:/Temp/ldd-pres-{código}/"

# Colores del tema (leer desde tema-visual o usar defaults)
C_BG      = RGBColor(0x0D, 0x1B, 0x2A)   # Fondo oscuro
C_ACCENT  = RGBColor(0xE8, 0x87, 0x1E)   # Acento naranja
C_TEXT    = RGBColor(0xFF, 0xFF, 0xFF)   # Texto principal
C_TEXT2   = RGBColor(0xB0, 0xBE, 0xC5)  # Texto secundario
C_HUELLA  = RGBColor(0x00, 0xBC, 0xD4)  # Huella BBOK (cyan)

# Dimensiones 16:9 widescreen
W = Inches(13.333)
H = Inches(7.5)

prs = Presentation()
prs.slide_width = W
prs.slide_height = H

BLANK = prs.slide_layouts[6]  # Blank layout

def hex_to_rgb(hex_str):
    """'#E8871E' o 'E8871E' → RGBColor"""
    h = hex_str.lstrip('#')
    return RGBColor(int(h[0:2],16), int(h[2:4],16), int(h[4:6],16))

def add_rect(slide, left, top, width, height, fill_rgb, alpha=None):
    from pptx.util import Emu
    shape = slide.shapes.add_shape(1, left, top, width, height)
    shape.fill.solid()
    shape.fill.fore_color.rgb = fill_rgb
    shape.line.fill.background()
    return shape

def add_picture_safe(slide, img_path, left, top, width, height):
    """Agrega imagen si existe; si no, agrega rectángulo placeholder."""
    if img_path and os.path.exists(img_path):
        return slide.shapes.add_picture(img_path, left, top, width, height)
    else:
        return add_rect(slide, left, top, width, height, RGBColor(0x2A, 0x3A, 0x4A))

def add_text(slide, text, left, top, width, height,
             font_size=24, bold=False, color=None, align=PP_ALIGN.LEFT, wrap=True):
    from pptx.util import Pt
    color = color or C_TEXT
    txBox = slide.shapes.add_textbox(left, top, width, height)
    tf = txBox.text_frame
    tf.word_wrap = wrap
    p = tf.paragraphs[0]
    p.alignment = align
    run = p.add_run()
    run.text = text
    run.font.size = Pt(font_size)
    run.font.bold = bold
    run.font.color.rgb = color
    run.font.name = "Arial"
    return txBox

def add_overlay(slide, opacity_pct=60):
    """Rectángulo semitransparente para legibilidad sobre imagen."""
    shape = add_rect(slide, 0, 0, W, H, RGBColor(0x0D, 0x1B, 0x2A))
    # Ajustar transparencia via XML
    spPr = shape.fill._xPr
    fmtScheme = spPr.find(qn('a:solidFill'))
    if fmtScheme is not None:
        srgb = fmtScheme.find(qn('a:srgbClr'))
        if srgb is None:
            srgb = etree.SubElement(fmtScheme, qn('a:srgbClr'))
            srgb.set('val', '0D1B2A')
        alpha_el = etree.SubElement(srgb, qn('a:alpha'))
        alpha_el.set('val', str(opacity_pct * 1000))
    return shape

# ====================================================================
# SLIDES — generadas desde el storyboard parseado
# ====================================================================
{slide_generation_code}

# ====================================================================
prs.save(OUTPUT_PATH)
print(f"Presentación guardada: {OUTPUT_PATH}")
print(f"Total slides: {len(prs.slides)}")
```

**Funciones de layout por tipo (insertar en `{slide_generation_code}`):**

```python
# ── PORTADA ──────────────────────────────────────────────────────────
def build_portada(slide_data):
    slide = prs.slides.add_slide(BLANK)
    add_picture_safe(slide, slide_data.get('img_path'), 0, 0, W, H)
    add_overlay(slide, 70)
    # Línea de acento superior
    add_rect(slide, 0, 0, W, Inches(0.08), C_ACCENT)
    # Nombre del curso (centrado, tercio superior)
    add_text(slide, slide_data['titulo'],
             Inches(1), Inches(2.2), Inches(11.3), Inches(2),
             font_size=40, bold=True, align=PP_ALIGN.CENTER)
    # Subtítulo o dominio si existe
    if slide_data.get('texto_pantalla'):
        add_text(slide, slide_data['texto_pantalla'][0].get('Texto',''),
                 Inches(1), Inches(4.2), Inches(11.3), Inches(0.8),
                 font_size=20, color=C_TEXT2, align=PP_ALIGN.CENTER)
    # Línea de acento inferior
    add_rect(slide, 0, H - Inches(0.06), W, Inches(0.06), C_ACCENT)

# ── AGENDA ───────────────────────────────────────────────────────────
def build_agenda(slide_data):
    slide = prs.slides.add_slide(BLANK)
    add_rect(slide, 0, 0, W, H, C_BG)
    add_rect(slide, 0, 0, Inches(0.1), H, C_ACCENT)
    add_text(slide, "Contenido",
             Inches(0.4), Inches(0.4), Inches(6), Inches(0.8),
             font_size=28, bold=True)
    temas = [row.get('Texto','') for row in slide_data.get('texto_pantalla', [])]
    for i, tema in enumerate(temas):
        add_text(slide, f"{i+1}.  {tema}",
                 Inches(0.8), Inches(1.4 + i*0.72), Inches(11), Inches(0.65),
                 font_size=18, color=C_TEXT2)

# ── DIVISOR ──────────────────────────────────────────────────────────
def build_divisor(slide_data):
    slide = prs.slides.add_slide(BLANK)
    add_picture_safe(slide, slide_data.get('img_path'), 0, 0, W, H)
    add_overlay(slide, 65)
    # Número de tópico (si está en el título, ej: "Tópico 3")
    add_text(slide, slide_data['titulo'],
             Inches(0.8), Inches(2.8), Inches(11.7), Inches(1.8),
             font_size=44, bold=True, align=PP_ALIGN.CENTER)
    add_rect(slide, Inches(5.2), Inches(4.7), Inches(2.9), Inches(0.06), C_ACCENT)

# ── CONCEPTO ─────────────────────────────────────────────────────────
def build_concepto(slide_data):
    slide = prs.slides.add_slide(BLANK)
    add_rect(slide, 0, 0, W, H, C_BG)
    # Imagen en 55% izquierdo
    add_picture_safe(slide, slide_data.get('img_path'),
                     0, 0, Inches(7.3), H)
    # Panel de texto derecho (45%)
    add_rect(slide, Inches(7.3), 0, Inches(6.03), H, C_BG)
    add_rect(slide, Inches(7.3), 0, Inches(0.05), H, C_ACCENT)
    # Título
    add_text(slide, slide_data['titulo'],
             Inches(7.6), Inches(0.4), Inches(5.5), Inches(0.9),
             font_size=20, bold=True)
    # Elementos de texto (máx 3 bullets × 7 palabras)
    items = slide_data.get('texto_pantalla', [])[:3]
    for i, item in enumerate(items):
        label = item.get('Elemento', '')
        texto = item.get('Texto', '')
        if label:
            add_text(slide, label.upper(),
                     Inches(7.6), Inches(1.5 + i*1.5), Inches(5.5), Inches(0.4),
                     font_size=10, color=C_ACCENT, bold=True)
        add_text(slide, texto,
                 Inches(7.6), Inches(1.9 + i*1.5), Inches(5.5), Inches(0.9),
                 font_size=16, color=C_TEXT)
    # Huella BBOK (pequeña, esquina inferior)
    if slide_data.get('huella_bbok'):
        add_text(slide, slide_data['huella_bbok'],
                 Inches(7.6), Inches(6.9), Inches(5.5), Inches(0.4),
                 font_size=8, color=C_HUELLA)

# ── TÉCNICO ──────────────────────────────────────────────────────────
def build_tecnico(slide_data):
    slide = prs.slides.add_slide(BLANK)
    add_rect(slide, 0, 0, W, H, C_BG)
    # Header bar
    add_rect(slide, 0, 0, W, Inches(0.8), RGBColor(0x12, 0x28, 0x3A))
    add_text(slide, slide_data['titulo'],
             Inches(0.3), Inches(0.12), Inches(11), Inches(0.6),
             font_size=18, bold=True)
    # Área de diagrama/imagen (centrada)
    add_picture_safe(slide, slide_data.get('img_path'),
                     Inches(1.5), Inches(1.0), Inches(10.3), Inches(5.6))
    # Labels del TEXTO EN PANTALLA superpuestos
    items = slide_data.get('texto_pantalla', [])
    for i, item in enumerate(items[1:3]):  # Primeros 2 labels después del header
        add_text(slide, item.get('Texto', ''),
                 Inches(0.2 + i*6.5), Inches(5.8), Inches(6), Inches(0.6),
                 font_size=13, color=C_TEXT2)
    # Huella BBOK
    if slide_data.get('huella_bbok'):
        add_text(slide, slide_data['huella_bbok'],
                 Inches(10.5), Inches(6.9), Inches(2.8), Inches(0.4),
                 font_size=8, color=C_HUELLA)

# ── EJEMPLO ──────────────────────────────────────────────────────────
def build_ejemplo(slide_data):
    slide = prs.slides.add_slide(BLANK)
    add_rect(slide, 0, 0, W, H, C_BG)
    add_rect(slide, 0, 0, W, Inches(0.06), C_ACCENT)
    add_text(slide, slide_data['titulo'],
             Inches(0.5), Inches(0.2), Inches(12.3), Inches(0.8),
             font_size=22, bold=True)
    add_picture_safe(slide, slide_data.get('img_path'),
                     Inches(0.5), Inches(1.2), Inches(6.5), Inches(5.4))
    # Datos del caso (texto derecho)
    items = slide_data.get('texto_pantalla', [])
    for i, item in enumerate(items):
        add_text(slide, item.get('Texto', ''),
                 Inches(7.3), Inches(1.5 + i*1.3), Inches(5.7), Inches(1.1),
                 font_size=15, color=C_TEXT2 if i > 0 else C_TEXT)

# ── ACTIVIDAD ────────────────────────────────────────────────────────
def build_actividad(slide_data):
    slide = prs.slides.add_slide(BLANK)
    add_rect(slide, 0, 0, W, H, C_BG)
    add_rect(slide, 0, 0, Inches(0.12), H, C_ACCENT)
    add_text(slide, "ACTIVIDAD",
             Inches(0.4), Inches(0.3), Inches(4), Inches(0.5),
             font_size=12, bold=True, color=C_ACCENT)
    add_text(slide, slide_data['titulo'],
             Inches(0.4), Inches(0.9), Inches(12.6), Inches(1.2),
             font_size=28, bold=True)
    items = slide_data.get('texto_pantalla', [])
    for i, item in enumerate(items):
        add_text(slide, item.get('Texto', ''),
                 Inches(0.8), Inches(2.3 + i*0.8), Inches(11.5), Inches(0.7),
                 font_size=16, color=C_TEXT2)
    # Tiempo en esquina inferior derecha
    tiempo = next((r.get('Texto','') for r in items if 'tiempo' in r.get('Elemento','').lower() or 'min' in r.get('Texto','').lower()), '')
    if tiempo:
        add_text(slide, tiempo,
                 Inches(10.5), Inches(6.5), Inches(2.7), Inches(0.7),
                 font_size=22, bold=True, color=C_ACCENT, align=PP_ALIGN.RIGHT)

# ── CIERRE ───────────────────────────────────────────────────────────
def build_cierre(slide_data):
    slide = prs.slides.add_slide(BLANK)
    add_rect(slide, 0, 0, W, H, C_BG)
    add_rect(slide, 0, 0, W, Inches(0.08), C_ACCENT)
    add_rect(slide, 0, H - Inches(0.08), W, Inches(0.08), C_ACCENT)
    add_text(slide, slide_data['titulo'],
             Inches(0.5), Inches(0.3), Inches(12.3), Inches(0.9),
             font_size=28, bold=True, align=PP_ALIGN.CENTER)
    items = slide_data.get('texto_pantalla', [])
    for i, item in enumerate(items):
        add_text(slide, f"  {item.get('Texto','')}",
                 Inches(1.5), Inches(1.4 + i*0.9), Inches(10.3), Inches(0.8),
                 font_size=18, color=C_TEXT2)
    add_rect(slide, Inches(0.5), Inches(1.3), Inches(0.06),
             Inches(len(items)*0.9), C_ACCENT)

# ── DISPATCHER ───────────────────────────────────────────────────────
BUILDERS = {
    'PORTADA':   build_portada,
    'AGENDA':    build_agenda,
    'DIVISOR':   build_divisor,
    'CONCEPTO':  build_concepto,
    'TÉCNICO':   build_tecnico,
    'TECNICO':   build_tecnico,
    'EJEMPLO':   build_ejemplo,
    'ACTIVIDAD': build_actividad,
    'CIERRE':    build_cierre,
}

slides_data = {slides_list}  # Insertar la lista de dicts parseados

for sd in slides_data:
    builder = BUILDERS.get(sd['tipo'].upper(), build_concepto)
    builder(sd)
```

### 8. Validar el output

```python
# Al final del script, verificar:
assert os.path.exists(OUTPUT_PATH), "ERROR: archivo no generado"
from pptx import Presentation as P2
check = P2(OUTPUT_PATH)
assert len(check.slides) == len(slides_data), f"ERROR: {len(check.slides)} slides vs {len(slides_data)} esperadas"
print(f"✓ Validación OK — {len(check.slides)} slides")
```

Si la validación falla: leer el error, corregir el script y re-ejecutar.

### 9. Guardar en Engram y reportar

```python
mem_save(
    title=f"Presentación .pptx generada para {código}",
    topic_key=f"ldd/{código}/presentation-path",
    type="decision",
    content={
        "path": OUTPUT_PATH,
        "slides": len(slides_data),
        "images_matched": N_matched,
        "images_placeholder": N_placeholder,
        "icons_used": N_icons,
    }
)
```

Reportar al usuario:
```
✅ Presentación generada: {OUTPUT_PATH}
   Total slides: {N}
   Imágenes desde SharePoint: {N_matched}
   Imágenes placeholder: {N_placeholder}
   Íconos Iconify: {N_icons}
   [PENDIENTE CONFIRMACIÓN] si hay imágenes placeholder
```

---

## Tema visual por defecto

Usar cuando no existe `ldd/{código}/tema-visual` en Engram:

| Variable | Valor por defecto | Hex |
|---|---|---|
| `C_BG` | Azul marino oscuro | `#0D1B2A` |
| `C_ACCENT` | Naranja industrial | `#E8871E` |
| `C_TEXT` | Blanco | `#FFFFFF` |
| `C_TEXT2` | Gris azulado | `#B0BEC5` |
| `C_HUELLA` | Cyan (trazabilidad) | `#00BCD4` |
| Fuente | Arial | — |

Si el tema visual existe, reemplazar estos valores con los del Engram antes de generar el script.

---

## Limits

- El .pptx generado es **editable por el equipo de diseño gráfico** — es un punto de partida, no el entregable final
- Las imágenes de SharePoint se descargan en `C:/Temp/` — son temporales; el .pptx las embebe internamente al guardarse con python-pptx
- Si `cairosvg` no está disponible, omitir los íconos Iconify y marcar como `[PENDIENTE: íconos]` en el reporte
- **No inventar contenido**: todo texto en los slides viene del storyboard parseado — el sub-agente no redacta ni resume
- Máximo 3 elementos de texto por slide (regla heredada del storyboard)
- Si la lista de SharePoint retorna más de 200 archivos, paginar con `$top=200&$skipToken=...`
- **Las imágenes del BBOK tienen prioridad absoluta** sobre SharePoint — son el contenido técnico validado por el SME. No reemplazarlas con fotos genéricas aunque el score de SharePoint sea alto.
- Si una imagen BBOK es un diagrama técnico (.png con fondo blanco), considerar agregar una capa semitransparente oscura detrás del texto para mantener legibilidad

---

## Plan Update

Esta skill genera el entregable `.pptx` que corresponde a los ítems de diseño gráfico:

Al finalizar la generación del .pptx, actualiza el plan de gestión (`07_Planeación/plan-gestion.md`):

1. Marca al 100% las siguientes tareas:
   - ITEM 30 — Diseño gráfico de la presentación
   - ITEM 31 — Revisión y ajustes de diseño gráfico
2. Recalcula SPI de cada tarea marcada: SPI = 1,0
3. Recalcula SPI Global = EV acumulado ÷ PV de tareas cuyo FIN ya pasó
4. Actualiza el Resumen EVM en el encabezado del plan
5. Informa: "Tareas 30–31 marcadas ✅ en el plan. SPI Global: {valor}"

> Nota: Si las tareas 30–31 corresponden a diseño gráfico humano (no automatizado), marcarlas solo si el cliente o el diseñador confirmó el uso de este .pptx como entregable base. En ese caso preguntar al usuario antes de marcar.
