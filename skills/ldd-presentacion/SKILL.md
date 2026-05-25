---
name: ldd-presentacion
description: Genera el borrador completo de la presentación del curso, diapositiva por diapositiva, con contenido, notas al facilitador e indicaciones para el equipo de diseño gráfico.
triggers:
  - borrador presentación
  - presentación del curso
  - diapositivas
  - slides
  - generar presentación
  - storyboard presentación
  - contenido para diseño gráfico
metadata:
  version: "1.0"
  author: "ingnovarte"
  updated_at: "2026-05-25"
license: "proprietary"
---

## When to Use

Usa esta skill cuando:
- El BOK (o BBOK aprobado) y el Esquema están disponibles
- Necesitas el contenido completo de la presentación listo para que el equipo de diseño gráfico aplique la capa visual
- Estás en la fase de Creación produciendo los entregables del curso

No uses esta skill para:
- Generar el contenido técnico del curso (usa `ldd-bok`)
- Generar guías de actividades (usa `ldd-guias`)

## Steps

1. **Verificar prerequisitos**: buscar en Engram `ldd/{código}/esquema` y `ldd/{código}/bbok` (o `bok` si está disponible)
2. **Revisar el Esquema**: identificar la secuencia de tópicos, subtemas y la duración de cada momento
3. **Diseñar la arquitectura de diapositivas**:
   - Slide de apertura (portada)
   - Slide de agenda / tabla de contenido
   - Por cada tópico: 1 slide de introducción del tópico + N slides de contenido
   - Slide de cierre y síntesis por tópico
   - Slide de cierre general
4. **Por cada diapositiva**, completar: título, contenido, notas al facilitador, indicaciones para diseño
5. **Regla de contenido por slide**: máximo 5 bullets o 1 concepto central — si hay más, partir en múltiples slides
6. **Guardar en Engram**: `topic_key: ldd/{código}/presentacion`

## Outputs

```markdown
# Borrador Presentación — [Código] [Nombre del curso]
**Versión:** v1 | **Fecha:** | **Estado:** Borrador — pendiente capa gráfica

> Este documento es el insumo para el equipo de diseño gráfico.
> El diseñador aplica la identidad visual, animaciones y elementos gráficos sobre esta estructura.

---

## Slide 1 — Portada

**Título:** [Nombre del curso]
**Subtítulo:** [Programa] | [Cliente] | [Duración]

*Notas al facilitador:*
[instrucciones de apertura, saludo, presentación]

*Indicaciones para diseño:*
- Imagen de portada: [describir tipo de imagen — equipo industrial, ambiente de trabajo, etc.]
- Usar plantilla de portada oficial

---

## Slide 2 — Agenda

**Título:** Contenido del curso
**Contenido:**
1. [Tópico 1] — [X min]
2. [Tópico 2] — [X min]
3. [...]
4. Evaluación — [X min]

*Notas al facilitador:*
[cómo presentar la agenda, qué destacar]

*Indicaciones para diseño:*
- Lista numerada con íconos por tópico
- Estilo timeline si el curso tiene fases secuenciales claras

---

## Slide 3 — [Nombre del Tópico 1] (introducción)

**Título:** [Nombre del Tópico]
**Contenido:**
[1-2 frases que encuadran el tópico — qué es y por qué importa en el rol]

*Notas al facilitador:*
[cómo introducir el tópico, conexión con experiencia del participante]

*Indicaciones para diseño:*
- Imagen conceptual del tópico
- Número de tópico visible

---

## Slide 4 — [Subtema o concepto clave del Tópico 1]

**Título:** [título del concepto]
**Contenido:**
- [bullet 1]
- [bullet 2]
- [bullet 3]

*Notas al facilitador:*
[qué explicar, qué preguntar al grupo, ejemplos sugeridos]

*Indicaciones para diseño:*
- [tipo de gráfico: diagrama, tabla, fotografía, infografía]
- [descripción específica de lo que debe mostrar el gráfico]

---

[Continuar para cada tópico del Esquema...]

---

## Slide [N] — Cierre y síntesis

**Título:** ¿Qué aprendimos hoy?
**Contenido:**
- [síntesis punto 1]
- [síntesis punto 2]
- [síntesis punto 3]

*Notas al facilitador:*
[cómo facilitar la síntesis del grupo]

*Indicaciones para diseño:*
- Diseño visual de resumen / mapa mental simple

---

## Resumen de diapositivas

| # | Título | Tópico | Tipo |
|---|---|---|---|
| 1 | Portada | — | Portada |
| 2 | Agenda | — | Navegación |
| 3 | [Tópico 1] intro | Tópico 1 | Introducción |
| ... | | | |
| [N] | Cierre | — | Cierre |
| **Total** | | | **[N] slides** |
```

## Limits

- El borrador de presentación es el insumo del diseñador gráfico — no es el producto final
- No generar código HTML, CSS ni archivos ejecutables de presentación
- Máximo 5 bullets o 1 concepto central por diapositiva — dividir si hay más contenido
- Las notas al facilitador son para el instructor, no para el estudiante
- Las indicaciones para diseño deben ser descriptivas y específicas, no genéricas ("imagen bonita" no es válido)
- El número de slides debe ser proporcional a la duración del curso (referencia: ~1 slide por cada 3-5 minutos de contenido)

## Plan Update

Al finalizar la generación del borrador de presentación, actualiza el plan de gestión (`07_Planeación/plan-gestion.md`):

1. Marca al 100% las siguientes tareas:
   - ITEM 23 — Elaboración contenido de la Presentación indicando estilo, tipos de animación, gráficos deseados
   - ITEM 24 — Revisión y ajustes del contenido de la presentación por Tópico
2. Recalcula SPI de cada tarea marcada: SPI = 1,0
3. Recalcula SPI Global = EV acumulado ÷ PV de tareas cuyo FIN ya pasó
4. Actualiza el Resumen EVM en el encabezado del plan
5. Informa: "Tareas 23 y 24 marcadas ✅ en el plan. SPI Global: {valor}"
